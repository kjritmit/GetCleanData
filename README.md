---
title: "README.md"
author: "Karen Rittenhouse Mitchell"
date: "October 25, 2015"
output: html_document
---

This README documents sources, necessary inputs, ancillary data locations, etc. for the 
course project for "Getting and Cleaning Data", a MOOC offered by Johns Hopkins University
Bloomberg School of Public Health on Coursera.  

The course project is to construct a small tidy dataset from data collected from the
accelerometers from the Samsung Galaxy S smartphone. A full description of the raw dataset
is available at thesite where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The raw data for the project were not downloaded directly from this site, but rather
downloaded as a .zip archive from the location below, as specified by the project 
instructions.

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

These data originated from the work of:  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, 
Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a 
Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient 
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.  

The files in the downloaded archive were extracted using functionality of the operating 
system of the computer which downloaded them (MacOS Yosemite 10.10.5). The files needed for
construction of the tidy data set were then copied into the working directory for the R
project.  These files are:

* activity_labels.txt 
* features.txt 
* X_test.txt 
* y_test.txt
* subject_test.txt
* X_train.txt
* y_train.txt
* subject_train.txt

Complete descriptions of these files and the data they contain are included in the .zip 
archive, and herein by reference. 

The raw files listed above were processed using the script run_analysis.R.  This script 
(1) merges the training and the test sets to create one data set, 
(2) extracts only the measurements on the mean and standard deviation for each measurement, 
(3) uses descriptive activity names to name the activities in the data set,
(4) appropriately labels the data set with descriptive variable names, and
(5) from the data set in step 4, creates a second, independent tidy data set with the
average of each variable for each activity and each subject.

The script reads in the test data, column binding the associated subject number, activity
code, and data creating a data frame named test_data, and then reads in the train data,
column binding the subject number, activity code, and data. It then reads in the features
labels for use as column names and combines the test and train data using rbind, adding
column names.

Only those columns containing subject or activity id, or the mean or std of measurements
based on the column name (feature names as provided in the orignal data) were selected to
include in the tidy data set, as specified by the project instructions. Features that were
identified as frequency counts of mean and std, rather than calculated mean or std, were
removed.  This resulted in 68 variables - two identifiers (subject, activity) and 66 mean 
or std features.

To further tidy the data set, numeric activity codes were replaced with descriptive names
by reading in the activity_labels.txt data and replacing the numeric codes with the text
labels using the mutate function in the dplyr package.  Symbols/punctuation in the provided 
feature names were removed by substituting "" for "()" and "-" to create tidy variable
names.  

Finally the data were reshaped using the reshape2 package to melt the data frame to one, 
long frame with subject and activity as identifiers, and all other columns as variables.
This long data frame was then recast using dcast to summarize the data by subject and
activity, presenting the mean of all available data for each subject/activity combination,
and the resulting small, tidy data set was output to "tidy_small.txt".