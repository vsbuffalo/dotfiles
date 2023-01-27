CRAN_PKGS <- c('devtools', 'microbenchmark', 'tidyverse',
               'knitr', 'reshape2', 'rstan', 'docopt', 'lubridate', 'testhat',
               'roxygen2', 'gsl',
               'rmarkdown', 'inline', 'Rcpp', 'RcppEigen', 
               'wesanderson', 'viridis', 'latex2exp', 'extrafont', 'tikzDevice')

BIOC_PKGS <- c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures',
               'VariantAnnotation', 'rhdf5', 'plyranges')


install.packages(CRAN_PKGS)

## Install Bioconductor Package
#source('http://bioconductor.org/biocLite.R')
#biocLite(BIOC_PKGS)
#biocLite(ask=FALSE)
#
#
