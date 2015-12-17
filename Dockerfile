FROM danielak/ubuntu-trusty

# Global Variables
# Making one change to RBRANCH toggles this from pre-release (R-devel) to base (current R)
ENV RVERSION R-devel
ENV CRANURL https://stat.ethz.ch/R/daily/

# Add R Repository for CRAN packages
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Get the system ready to build R from source
RUN apt-get update && apt-get build-dep --assume-yes \
    r-base \
    r-cran-rgl

# Build and install R from source
RUN wget "$CRANURL$RVERSION.tar.gz" && \
    mkdir /$RVERSION && \
    tar --strip-components 1 -zxvf $RVERSION.tar.gz  -C /$RVERSION && \
    cd /$RVERSION && \
    ./configure --enable-R-shlib && \
    make && \
    make install

# Install Devtools
RUN R --vanilla -e "install.packages('devtools', dep = TRUE, repos = 'http://cran.rstudio.com')"

# Check Package
RUN mkdir -p /package
CMD [ \
    "R", \
    "--vanilla", \
    "-e", \
    "devtools::install('/package'); \
        options(repos = c(CRAN='http://cran.rstudio.com')); \
        devtools::check( \
          '/package', \
          cran = TRUE, \
          check_version = TRUE \
        )" \
]
