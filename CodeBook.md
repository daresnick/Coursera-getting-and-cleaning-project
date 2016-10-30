
# Code Book

##**Introduction:**   
The script `run_analysis.R` does the cleaning and merging of the data per these instructions:  
1.	Merges the training and the test sets to create one data set.  
cbind() and rbind(0 are used to combine the data files  
2.	Extracts only the measurements on the mean and standard deviation for each measurement.  
grepl() is used to find the mean and sd columns  
3.	Uses descriptive activity names to name the activities in the data set  
merge() is used  
4.	Appropriately labels the data set with descriptive variable names.  
columns are simply renamed  
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
melt and dcast are used to summarize the means for each set  

- The data and data folders were previously loaded to the working directory for the run_analysis.R script.  

- The final output of the script is a tidy data set tidydata.txt.  

- The script `run_analysis.R` is well commented to explain each step and the code used.  

##**Variables and Data:**   
- activityLabels and features contain the types of activities and variable names 
- xTrain, yTrain, subjectTrain, xTest, yTest, subjectTest contain the downloaded data
- trainData and testData combine the two sets of data in allData
- finalData2 includes the merged data along with the activity labels
- finalData3mean dcasts the melted data from finalData3melt which is turned into `tidydata.txt`


