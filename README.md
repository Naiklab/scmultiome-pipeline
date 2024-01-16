## scMulitome Analysis Pipeline
#### Naik Lab
##### Joseph Daccache (01/16/2024)
This github repo contains the necessary scripts to run sc multiome (expected 10X Genomics output) entirely from BASH.  
The pipeline incorporates _Seurat_, _Signac_, and _SCENIC+_ analytical workflows  

### Installation
In the directory of your choosing, clone this repository, rename it as your desired project directory, and run the `init` command to set up your directories and confugre your wrapper scripts.
```
git clone https://github.com/jad362/scmultiome-pipeline.git
mv scmultiome-pipeline {project_name}
cd {project_name}

# load R in whichever way is easiest for you, on an HPC, using module load is best
module load r

# make the master script executable
chmod +x runmultiome.sh
runmultiome.sh init
```





Let's test the installation by running our tester file and looking for the help message
```
./test.R -h
```
```
usage: test.R [--] [--help] [--opts OPTS] [--digits DIGITS] number

Round a floating point number

positional arguments:
  number        number to round

flags:
  -h, --help    show this help message and exit

optional arguments:
  -x, --opts    RDS file containing argument values
  -d, --digits  number of decimal places [default: 0]
```
Now let's see if the script can take in arguments and perform the expected tasks
```
./test.R 3.14159 
./test.R 3.14159 -d 2
```
```
3 
3.14
```

### Running our scMulitome pipeline
After ensuring argparser is functional, let's test out our pipeline and make sure it is executable and working
```
scripts/multiome-processing.R -h
```
```
usage: multiome-processing-v0.1.R [--] [--help] [--opts OPTS]
       [--outfilename OUTFILENAME] [--grouping.var GROUPING.VAR]
       [--RDS.file.in RDS.FILE.IN] [--runHarmony RUNHARMONY]
       [--footprint-peaks FOOTPRINT-PEAKS] [--my.macs2.path
       MY.MACS2.PATH] pipeline samplesheet

Run single-cell RNA + ATAC Multiomic Analysis from 10X Genomics
platform

positional arguments:
  pipeline               Comma delimted combinations of: init, create,
                         callpeaks, qc, cluster, merge, linkpeaks
  samplesheet            samplesheet in csv format

flags:
  -h, --help             show this help message and exit

optional arguments:
  -x, --opts             RDS file containing argument values
  -o, --outfilename      outfile name, no .RDS! [default:
                         data/r-objects/multiome-object]
  -g, --grouping.var     grouping variable for peak calling algorithm
                         [default: NA]
  -R, --RDS.file.in      RDS in-file for the pipeline desired [default:
                         NA]
  -r, --runHarmony       whether or not to run Harmony batch correction
                         [default: FALSE]
  -f, --footprint-peaks  atac peaks to run footprinting analysis on.
                         txt file
  -m, --my.macs.path     path to macs environment. only used if
                         callpaks pipeline is run
```
As the output indicates, the scripts excepts 2 mandatory arguments: pipeline(s) and samplesheet.  
The example samplesheet shows what a samplesheet looks like.  
IMPORTANT: the pipeline expects `sampleName` and `path` in a case sensitive manner and all sample-level meta data information to be added to come *after* the `path` column

|sampleName|path|cond|
|---|---|---|
|ctrl.1|/gpfs/data/sequence/results/naiklab/2023-03-24/cellranger/count-CTRL/outs|ctrl|
|il17.1|/gpfs/data/sequence/results/naiklab/2023-03-24/cellranger/count-IL-17/outs|il17a|

