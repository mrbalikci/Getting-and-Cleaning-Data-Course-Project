# reshape2 makes it easy to transform data between wide and long formats.

library(reshape2)

# download zip file in working directory 
filename <- "activity_tracking.zip"
if(!file.exists(filename)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,filename,method = "curl")
  }

# extract the zip file in working directory 
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

# read activity_labels text file 
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# read 2nd column of activity_labels as character
activityLabels[,2] <- as.character(activityLabels[,2])

# read features text file
features <- read.table("UCI HAR Dataset/features.txt")

# read 2nd column of features as character
features[,2] <- as.character(features[,2])

# Grab mean and standard deviation only from features veriables
featuresGrab <- grep(".*mean.*|.*std.*", features[,2])

# extract the places of mean & std as 2nd column 
featuresGrab.names <- features[featuresGrab,2]

# substitute -mean with Mean 
featuresGrab.names <- gsub('-mean', 'Mean', featuresGrab.names)

# substitute -std with Std
featuresGrab.names <- gsub('-std', 'Std', featuresGrab.names)

# ged rid of -() in mean & std in features 
featuresGrab.names <- gsub('[-()]','', featuresGrab.names)


# load the test datasets 

testSet <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresGrab]
testLabels <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

testSet <- cbind(testSubjects, testLabels, testSet)

# load the train datasets 

trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresGrab]
trainLabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

trainSet <- cbind(trainSubjects, trainLabels, trainSet)

# merge train & test data sets and labels 

data <- rbind(trainSet, testSet)
colnames(data) <- c("subject", "activity", featuresGrab.names)

# turn activities & subjects into factors 

data$activity <- factor(data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
data$subject <- as.factor(data$subject)

data.melted <- melt(data, id=c("subject","activity"))
data.mean <- dcast(data.melted, subject+activity~variable, mean)


# Write the tidy datasests as tidy.txt 

write.table(data.mean, "tidy.txt", row.name = FALSE, quote = FALSE)


readTidy <- read.table("C:/Users/NWC food San Antonio/Documents/Data Science/Data Scientist Tools/Course 3 Data Cleaning/Week4/Project/tidy.txt")

