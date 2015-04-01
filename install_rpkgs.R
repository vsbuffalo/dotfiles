CRAN_PKGS <- c('devtools', 'microbenchmark', 'ggplot2', 'plyr', 'dplyr', 'knitr',
               'reshape2', 'rstan')

BIO_PKGS <- c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures',
              'VariantAnnotation')


install.packages(PKGS)

# Install Bioconductor Package
source('http://bioconductor.org/biocLite.R');
biocLite(BIO_PKGS)



