## Extract results of interest, write TAF output tables

## Before:
## After:

library(icesTAF)

# Create out directory
mkdir("output")

# Copy model reports into output directory
cp(list.files("model/output/baseline/report", "^2.+[.]txt$", full.names = TRUE), "output")
