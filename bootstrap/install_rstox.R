library(icesTAF)

mkdir("../../library")

# https://github.com/Sea2Data/Rstox

# Install the packages that Rstox depends on. Note that this updates all the specified packages to the latest (binary) version:
#dep.pck <- c("data.table", "ggplot2", "pbapply", "rgdal", "rgeos", "rJava", "sp", "XML")
#install.packages(dep.pck, repos="http://cran.us.r-project.org", type="binary")

# Install Rstox:
install.packages("ftp://ftp.imr.no/StoX/Download/Rstox/Rstox_1.11.tar.gz", repos=NULL, lib="../../library")
