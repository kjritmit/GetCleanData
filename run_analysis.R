## Create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.

## Downloaded and extracted .zip archive on 23-Oct-2015 from 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## and placed all files into working directory.

library(dplyr)


## read in the test data, column binding the subject number, activity code, and data.
X_test <- read.table("X_test.txt")
Y_test <- read.table("Y_test.txt")
sub_test <- read.table("subject_test.txt")
test_data <- cbind(sub_test, Y_test, X_test)

## read in the train data, column binding the subject number, activity code, and data.
X_train <- read.table("X_train.txt")
Y_train <- read.table("Y_train.txt")
sub_train <- read.table("subject_train.txt")
train_data <- cbind(sub_train, Y_train, X_train)

## read in the features labels
features <- read.table("features.txt")

## combine the test and train data, and add column names (Addresses #1, 4)
all_data <- rbind(test_data, train_data)
colnames(all_data) <- c("subject", "activity", as.character(features[, 2]))

## select only those columns that are mean or std of measurements (Addresses #2)
mean_std_msmt <- all_data[, grep("subject|activity|mean|std", names(all_data), value = TRUE)]
mn_std_no_freq <- mean_std_msmt[, grep("Freq", names(mean_std_msmt), invert = TRUE, 
                                       value = TRUE)]

## Replace activity codes with descriptive activity names. (Addresses #3)
activities <- read.table("activity_labels.txt")
tidy_full <- mutate(mn_std_no_freq, activity = activities[activity,2])

## Clean up variable names (no symbols, punctuation, white space) (finishes #4)
names(tidy_full) <- gsub("()", "", names(tidy_full), fixed = TRUE)
names(tidy_full) <- gsub("-", "", names(tidy_full), fixed = TRUE)

## Reshape data in prep to create small tidy data set
library(reshape2)

tidy_long <- melt(tidy_full, id=c("subject", "activity"))

## output .txt file of small tidy data set (Addresses #5)
varbyactsub <- dcast(tidy_long, subject + activity ~ variable, mean)
write.table(varbyactsub, file = "tidy_small.txt", row.names = FALSE)
