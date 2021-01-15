## Run analysis, write model results

## Before:
## After:

library(icesTAF)
library(Rstox)
library(rJava)

# Create model directory
mkdir("model")

# Create StoX project directories
mkdir("model/input/acoustic")
mkdir("model/input/biotic")
mkdir("model/process")
mkdir("model/output")

# Copy data into StoX directories
cp(list.files("data", "^Acoustic.+[.]xml$", full.names = TRUE),
   to = "model/input/acoustic")
cp(list.files("data", "^Biotic.+[.]xml$", full.names = TRUE),
   to = "model/input/biotic")
cp(list.files("data", "^.+project[.]xml$", full.names = TRUE),
   to = "model/process/project.xml")

######################################################################
# Run StoX project
######################################################################

projectName <- file.path(getwd(), "model")

options(java.parameters = "-Xmx2000m") # increase RAM for Java VM
.jinit()

openProject(projectName)
runBaseline(projectName = projectName, save = TRUE, exportCSV = TRUE,
            modelType = c("baseline"))
runBaseline(projectName = projectName, save = TRUE, exportCSV = TRUE,
            modelType = c("baseline-report"))

currentBaseLineReport <- getBaseline(projectName, save = FALSE, exportCSV = FALSE,
            modelType = c("baseline-report"))

# save(currentBaseLineReport, file = file.path("model", "BaseLineReport.RData"),
#      compress = "xz")

.jcall("java/lang/System", method = "gc")
