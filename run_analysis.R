library(tidyverse)

if (!file.exists("data")){
  dir.create("data")
}
fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/analysisdata.zip", mode = "wb")
filename <- "./data/analysisdata.zip"
unzip(zipfile = filename, exdir = "./data")
list.files("./data/UCI HAR Dataset/train")
list.files("./data/UCI HAR Dataset/test")
list.files("./data/UCI HAR Dataset")

#read files into variables

trainX <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testX <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
activityLabel <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# search for mean and stddeviation
meanvector <- grepl("mean()", features$V2, fixed = TRUE)
stdvector <- grepl("std()", features$V2, fixed = TRUE)
v1vector <- features[meanvector | stdvector, 1]

#filter by mean and stddeviation
testXfiltered <- testX[v1vector]
trainXfiltered <- trainX[v1vector]

#rename Subject and Activity File and subset Activity code to descriptive names

trainSubject <- rename(trainSubject, "Subject" = "V1")
trainY <- rename(trainY, "Activity" = "V1")
testSubject <- rename(testSubject, "Subject" = "V1")
testY <- rename(testY, "Activity" = "V1")

for (i in 1:nrow(activityLabel)){
  
  trainY[trainY == i] <- activityLabel[i,2]
  testY[testY == i] <- activityLabel[i, 2]
}

#merge train Data
trainData <- cbind(trainSubject, trainY, trainXfiltered)

#merge test data
testData <- cbind(testSubject, testY, testXfiltered)

#merge train and test
mergedData <- rbind(trainData, testData)

#rename column-names
nameCol <- c(names(mergedData))

for (i in 3:length(nameCol)){

  activityNumber <- as.numeric(str_remove(names(mergedData[i]), "V"))
  nameCol[i] <- features[activityNumber, 2]
  
}

colnames(mergedData) <- nameCol

#create new data set with average for each subject and activity

newdf <- data.frame(a = 1:30, matrix(nrow = 30 * nrow(activityLabel), ncol = length(nameCol)))
colnames(newdf) <- nameCol

#for loop for assignin activity to subject

k <- 1

for (i in 1:nrow(newdf)){
  
  if (i >= 31 & i < 61){
    k <- 2
  }else if (i >= 61 & i < 91){
    k <- 3
  }else if (i >= 91 & i < 121){
    k <- 4
  } else if (i >= 121 & i < 151){
    k <- 5
  }else if (i >= 151){
    k <- 6
  }
  
  newdf[i, 2] <- k
  
}
#rename activity code
for (i in 1:nrow(activityLabel)){
  
  newdf$Activity[newdf$Activity == i] <- activityLabel[i,2]

}
newdf[1,2]

#fill mean values for each row
for (j in 1:nrow(newdf)){
for (i in 3:length(nameCol)){
  
      meanSubject <- mean(mergedData[[i]][mergedData$Subject == newdf[j,1] & mergedData$Activity == newdf[j,2]])
      newdf[j,i] <- meanSubject     
}
}

write.table(newdf, file = "./data/run_analysis_meanoutput.txt", row.names = FALSE)

