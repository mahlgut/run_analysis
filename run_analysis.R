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
dim(testXfiltered)

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
names(mergedData)
length(names(mergedData))
nameCol <- c(names(mergedData))

for (i in 3:length(nameCol)){

  activityNumber <- as.numeric(str_remove(names(mergedData[i]), "V"))
  nameCol[i] <- features[activityNumber, 2]
  
}

colnames(mergedData) <- nameCol

#create new data set with average for each subject and activity

newdf <- data.frame(matrix(nrow = 0, ncol = length(nameCol)))
colnames(newdf) <- nameCol

#unname activitylabels
mergedDatanew <- mergedData

for (i in 3:length(nameCol)){

  for (j in 1:30){
  
    for (k in 1:nrow(activityLabel)){
  
      meanSubject <- mean(mergedData[i][mergedData$Subject == j & mergedData$Activity == k])
      newdf$Subject <- j
      newdf$Activity <- k
    }
  }
}
