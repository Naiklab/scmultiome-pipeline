#!/bin/bash

module load r/4.1.2

# install the required packages to make scmultiome executable in the desired directory
mkdir .lib
git clone https://bitbucket.org/djhshih/argparser.git .lib/argparser
mv scripts/install.R .lib/argparser/
cd .lib/argparser
Rscript install.R
R CMD INSTALL .

chmod +x ../../scripts/multiome-processing.R
