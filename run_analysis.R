## Getting & Cleaning Data: Final Project - Human Activity Recognition Using Smartphones Dataset

## Go to the directory where you want to download the files. Replace the value below with the directory path where you will work

setwd("~/Documents/Coursera/Getting_Cleaning_Data/Week4/Asgn")

## Define the variable for the dataset url from where you will get the source data

dataset_url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Check if data directory exists and create one if it does not

if (!file.exists("data")) {dir.create("data")}

## Define variable for the destination zip file

zipfile="data/UCI_HAR_data.zip"

##download and unzip file

download.file(dataset_url, destfile=zipfile, method="curl”)

unzip(zipfile,exdir=“data")
        
## Now load the required packages

library(reshape2)
        
## Read the required source data sets into data frame

## Read Training set
        
X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt”)

## Read 'train/y_train.txt': Training labels.

y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt”)
                      
  ## Read 'test/X_test.txt': Test set.
                      
X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt”)

## Read 'test/y_test.txt': Test labels.

y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt”)
                     
## Read files for subject details 
                     
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
                     
                     
## Merge the two data sets
                     
subject_combined <- rbind(subject_train,subject_test)
 readings_combined <- rbind(X_train,X_test)
activity_combined <- rbind(y_train,y_test)
                     
## load the 561 names for features
                     
>feature_labels <- read.table("data/UCI HAR Dataset/features.txt")[,2]
                     
## Use the information from features.txt to label the 561 columns
                     
colnames(readings_combined) <-feature_labels
                     
                     
## Also include the subjects and activity column names for readability
                     
colnames(subject_combined) <-"Subject"
colnames(activity_combined) <-"Activity"
                     
## Now merge all three data sets
 complete_dataset <-cbind(subject_combined,activity_combined,readings_combined)
                     
                     
 ## Next as per requirement we will extract columns with either Mean or Std (standard deviation)
dataset_MeanStd <- grep(".*Mean.*|.*Std.*",names(complete_dataset), ignore.case=TRUE)
                     
## Include the Subject and Activity columns to this list
                     
 filtered_Col <-c(1,2,dataset_MeanStd)
                     
## Now create the filtered dataset with the column above
                     
filtered_Dataset <- complete_dataset[,filtered_Col]
                     
 ## Include descriptive activity names in the Activity fields. These are the provided in the activity_labels.txt"
                     
## load activity labels
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")[,2]
                     
filtered_Dataset$Activity <- for (i in 1:6) {filtered_Dataset$Activity[filtered_Dataset$Activity ==i] <- as.character(activity_labels[i,2])}
                     
##Appropriately labels the data set with descriptive variable names.
## After looking at the features_info.txt files here are some of replacements to applied to make column names more readable accelerometer (Acc), gyroscope (Gyro), magnitude(Mag), frequency(f)
                     
 names(filtered_Dataset) <-gsub("Acc", "Accelerometer",names(filtered_Dataset),ignore.case = TRUE)
names(filtered_Dataset) <-gsub("Gyro", "gyroscope",names(filtered_Dataset),ignore.case = TRUE)
names(filtered_Dataset) <-gsub("Mag", "Magnitude",names(filtered_Dataset),ignore.case = TRUE)
names(filtered_Dataset) <-gsub("^f", "Frequency",names(filtered_Dataset))

## From the above data set , create a second, independent tidy data set with the average of each variable for each activity and each subject.
                     
## First we will factor for the activity and subject variable
                     
filtered_Dataset$Activity <- as.factor(filtered_Dataset$Activity)
filtered_Dataset$Subject <- as.factor(filtered_Dataset$Subject)
                     
## Create final tidy dataset to output with average for each variable by Activity and Subject
                     
tidy_data <-aggregate(. ~Subject+Activity, filtered_Dataset, mean)
write.table(tidy_data,file="GettingandCleaningData_Project_TidyDataSet.txt",row.names=FALSE)