CRAN_PKGS <- c('devtools', 'microbenchmark', 'ggplot2', 'plyr', 'dplyr', 'knitr',
               'reshape2', 'rstan')

BIOC_PKGS <- c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures',
              'VariantAnnotation')


install.packages(CRAN_PKGS)

# Install Bioconductor Package
source('http://bioconductor.org/biocLite.R');
biocLite(BIOC_PKGS)
biocLite(ask=FALSE)


