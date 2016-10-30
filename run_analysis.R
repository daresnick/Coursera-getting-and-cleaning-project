
library(dplyr)
library(plyr)

setwd(".")
getwd()

### Data files and folders have already been downloaded into the working directory.

## 1.	Merges the training and the test sets to create one data set.

### First read the Labels, features, training, test, and subject data into R

activityLabels <- read.table("./activity_labels.txt")
features <- read.table("./features.txt")

xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")

xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")
subjectTest <- read.table("./test/subject_test.txt")


### Second use activityLabels and features to name the columns of the data.

names(activityLabels) <- c("activityNumber", "activityType")
names(features) <- c("featureNumber", "featureType")

names(xTrain) <- features[,2]
names(yTrain) <- "activityNumber"
names(subjectTrain) <- "subjectNumber"

names(xTest) <- features[,2]
names(yTest) <- "activityNumber"
names(subjectTest) <- "subjectNumber"


### Next make the training and test data sets by merging the Train sets and Test sets into two and then one set

trainData <- cbind(yTrain,subjectTrain,xTrain)
testData <- cbind(yTest,subjectTest,xTest)

allData <- rbind(trainData,testData)



## 2.	Extracts only the measurements on the mean and standard deviation for each measurement.

### In order to extract the mean and sd for each measurement we first need to get the column names for them

columnNames <- names(allData)


### Use columnNames to make a logical vector of Trues and Falses for the activity, subject, mean, and sd.
### Looking through the columnNames with count(grepl("mean",columnNames)) and such you can see we need to be careful
### We have to be careful to make sure to exclude -meanFreq, and -std()..-

v = (grepl("activity..",columnNames) | grepl("subject..",columnNames) | grepl("-mean..",columnNames) 
     & !grepl("-meanFreq..",columnNames) & !grepl("mean..-",columnNames) | grepl("-std..",columnNames) 
     & !grepl("-std()..-",columnNames))


### Make the finalData set using the logical vector and keeping only the True columns

finalData <- allData[v==TRUE]



## 3.	Uses descriptive activity names to name the activities in the data set

### Merge the final data set with the activityLabels so that the activityNumbers are more descriptive 
### and now correspond to the specific activity

finalData2 <- merge(activityLabels, finalData, by = "activityNumber")

finalcolumnNames <- names(finalData2)



## 4.	Appropriately labels the data set with descriptive variable names.

### Now we will give each column a more cleanly descriptive name

finalcolumnNames <- c("activityNumber", "activityType", "subjectNumber", 
                      "timeBodyAccMagMean", "timeBodyAccMagStd", "timeGravityAccMagMean", 
                      "timeGravityAccMagStd", "timeBodyAccJerkMagMean", "timeBodyAccJerkMagStd", 
                      "timeBodyGyroMagMean", "timeBodyGyroMagStd", "timeBodyGyroJerkMagMean", 
                      "timeBodyGyroJerkMagStd", "freqBodyAccMagMean", "freqBodyAccMagStd", 
                      "freqBodyAccJerkMagMean", "freqBodyAccJerkMagStd", "freqBodyGyroMagMean", 
                      "freqBodyGyroMagStd", "freqBodyGyroJerkMagMean", "freqBodyGyroJerkMagStd")
names(finalData2) <- finalcolumnNames


## 5.	From the data set in step 4, creates a second, independent tidy data set with the average 
##      of each variable for each activity and each subject.

### To make this easier we will remove the descriptive activityType

finalData3 <- finalData2[,-2]


### Now getting a little help from the reshape2 package, we will melt the data so that activity and subject line up with a variable

finalData3melt <- melt(finalData3, id = c("activityNumber","subjectNumber"))

### Then wave the magic dcast wand with the proper casting formula...

finalData3mean <- dcast(finalData3melt, activityNumber + subjectNumber ~ variable, mean)

### This final file now has the the mean of each variable for each activity and each subject

write.table(finalData3mean, "./tidydata.txt", row.names = FALSE)





