## Preprocess data, write TAF data tables

## Before: 
## After:

library(icesTAF)

# Create data directory
mkdir("data")

# Copy bootstrap data into data directory
cp("bootstrap/data/*.xml","data")
cp("bootstrap/data/download_data/*.xml","data")
cp("bootstrap/data/download_data/*Disclaimer.txt","data")
