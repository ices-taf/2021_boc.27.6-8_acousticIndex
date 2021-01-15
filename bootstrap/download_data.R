library(httr)
library(jsonlite)

# These are Acoustic WebAPI for downloading StoX files:
# 1.	List of all submission -> https://acoustic.ices.dk/services/Download/GetUploadlist/
# This service returns list of submitted cruise. You can get id for each cruise and pass to the bellow services to download Acoustic or Biotic StoX files.
#
# 2.	Download Acoustic StoX file -> https://acoustic.ices.dk/services/Download/DownloadStoXAcousticXML/{ID}
# eg. https://acoustic.ices.dk/services/Download/DownloadStoXAcousticXML/3
#
# 3.	Download Biotic StoX file ->  https://acoustic.ices.dk/services/Download/DownloadStoXBioticXML/{ID}
# eg. https://acoustic.ices.dk/services/Download/DownloadStoXBioticXML/3

# ------------------------------------------------------------------------------
# Get list of cruises / submissions uploaded into ICES Acoustic Trawl Portal
# ------------------------------------------------------------------------------

res <-
  GET(
    "https://acoustic.ices.dk/services/Download/GetUploadlist/",
    accept_json()
  )

uploads <-
  parse_json(
    content(res, as = "text"),
    simplifyVector = TRUE,
    flatten = TRUE
  )

cruises <-
  data.frame(
    ID = uploads$Cruise.ID,
    SurveyCode = substring(unlist(uploads$Cruise.Survey), 11),
    CountryCode = substring(uploads$Cruise.Country, 10),
    PlatformCode = substring(uploads$Cruise.Platform, 7),
    StartDate = uploads$Cruise.StartDate,
    EndDate = uploads$Cruise.EndDate,
    LocalID = uploads$Cruise.LocalID,
    AcousticSubmission = uploads$Cruise.AcousticSubmission,
    BioticSubmission = uploads$Cruise.BioticSubmission
  )

# ------------------------------------------------------------------------------
# Download Acoustic and Biotic files 
# ------------------------------------------------------------------------------

# Read data to download
data <- read.csv("../data_to_download.csv")

# Loop data to download
for (i in 1:nrow(data)) {
  platformCode <- data[i, "PlatformCode"]
  startDate <- data[i, "StartDate"]
  endDate <- data[i, "EndDate"]
  localID <- data[i, "LocalID"]
  
  # Find ID from ICES Acoustic Trawl database
  id <- cruises$ID[
    cruises$PlatformCode == platformCode &
    cruises$StartDate == startDate & 
    cruises$EndDate == endDate
    ]

  # Download Acoustic file
  url <- paste0("https://acoustic.ices.dk/services/Download/DownloadStoXAcousticXML/", id)
  dest <- file.path(paste0("Acoustic_", localID, ".zip"))
  download.file(url, dest, mode = "wb")
  unzip(dest)

  # Download Biotic file
  url <- paste0("https://acoustic.ices.dk/services/Download/DownloadStoXBioticXML/", id)
  dest <- file.path(paste0("Biotic_", localID, ".zip"))
  download.file(url, dest, mode = "wb")
  unzip(dest)
}
