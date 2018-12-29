#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download to working directory.

download.file(url,fileName, mode = "wb") 

#Read data 

subtrain <- read.table("gab/train/subject_train.txt")
ytrain <- read.table("gab/train/y_train.txt")
xtrain <- read.table("gab/train/X_train.txt")

subtest <- read.table("gab/test/subject_test.txt") 
ytest <- read.table("gab/test/y_test.txt")
xtest <- read.table("gab/test/X_test.txt") 

actlabels <- read.table("gab/activity_labels.txt")
features <- read.table("gab/features.txt") 


#Provide column names

colnames(subtrain) <- "subId"
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"

colnames(subtest) <- "subId"
colnames(xtest) <- features[,2]
colnames(ytest) <- "activityId" 

colnames(activityLabel)<-c("activityId","activityType")
 
#============================================================

#Problem 1 - Merges the training and the test sets to create one data set.

#Merge training Data
trainData <- cbind(ytrain,subrain,xtrain)

#Merge test Data
testData <- cbind(ytest,subtest,xtest)

#Final merging
finalDataSet <- rbind(trainData,testData)

#============================================================

#Problem 2 - Extract only the measurements on the mean and standard deviation for each measurement


measuremeanstd <-finalDataSet[,grepl("mean|std|subject|activityId",colnames(finalDataSet))]


#============================================================

#Problem 3 - Uses descriptive activity names to name the activities in the data set


library(plyr)
measuremeanstd  <- join(measuremeanstd, activityLabel, by = "activityId", match = "first")
measuremeanstd  <- measuremeanstd [,-1] 


#============================================================

#Problem 4 - Appropriately labels the data set with descriptive variable names.

names(measuremeanstd) <- gsub("\\(|\\)", "", names(measuremeanstd), perl  = TRUE)
names(measuremeanstd) <- make.names(names(measuremeanstd))
names(measuremeanstd) <- gsub("Acc", "Acceleration", names(measuremeanstd))
names(measuremeanstd) <- gsub("^t", "Time", names(measuremeanstd))
names(measuremeanstd) <- gsub("^f", "Frequency", names(measuremeanstd))
names(measuremeanstd) <- gsub("BodyBody", "Body", names(measuremeanstd))
names(measuremeanstd) <- gsub("mean", "Mean", names(measuremeanstd))
names(measuremeanstd) <- gsub("std", "Std", names(measuremeanstd))
names(measuremeanstd) <- gsub("Freq", "Frequency", names(measuremeanstd))
names(measuremeanstd) <- gsub("Mag", "Magnitude", names(measuremeanstd))

#============================================================

#Problem 5 - creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata_average_sub<- ddply(measuremeanstd, c("subject","activity"), numcolwise(mean))
write.table(tidydata_average_sub,file="tidydata.txt")




