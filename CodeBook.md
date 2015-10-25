---
title: "CodeBook.md"
author: "Karen Rittenhouse Mitchell"
date: "October 25, 2015"
output: html_document
---

This CodeBook documents study design, and variable descriptions made in creating the output
file tidy_small.txt for the "Getting and Cleaning Data", a MOOC offered by Johns Hopkins
University Bloomberg School of Public Health on Coursera, course project. 

The course project is to construct a small tidy dataset from data collected from the
accelerometers from the Samsung Galaxy S smartphone. A full description of the raw dataset
is available at thesite where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

These data originated from the work of:  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, 
Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a 
Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient 
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.  

The files used for construction of the tidy data set were:

* activity_labels.txt  -  description of activity codes
* features.txt  - descriptive names of features in feature vectors
* X_test.txt  - feature vectors for test data
* y_test.txt - activity codes for test data
* subject_test.txt - subject codes for test data
* X_train.txt - feature vectors for training data
* y_train.txt - activity codes for training data
* subject_train.txt - subject cods for training data

## Study design

The goals of the project were to: 
(1) merge the training and the test sets to create one data set, 
(2) extract only the measurements on the mean and standard deviation for each measurement, 
(3) use descriptive activity names to name the activities in the data set,
(4) appropriately label the data set with descriptive variable names, and
(5) from the data set in step 4, create a second, independent tidy data set with the
average of each variable for each activity and each subject.

The run_analysis.R script reads in the test data, column binding the associated subject
number, activity code, and data creating a data frame named test_data, and then reads in the
train data, column binding the subject number, activity code, and data. It then reads in the
features labels for use as column names and combines the test and train data using rbind,
adding column names.

Only those columns containing subject or activity id, or the mean or standard deviation
(std) of measurements based on the column name (feature names as provided in the orignal
data) were selected to include in the tidy data set, as specified by the project 
instructions. Features that were identified as frequency counts of mean and std (based on
inclusion of 'freq' in the feature name), rather than calculated mean or std, were
removed.  This resulted in 68 variables - two identifiers (subject, activity) and 66 mean 
or std features.

To further tidy the data set, numeric activity codes were replaced with descriptive names
by reading in the activity_labels.txt data and replacing the numeric codes with the text
labels using the mutate function in the dplyr package.  A review of the column names showed
that the original feature names used "()", and "-" to punctuate the names. Tidy data 
practices specify that no symbols, punctuation, or white space should be included in column
names, so punctuation in the provided feature names was removed by substituting "" for "()"
and "-" to create tidy variable names.  

The data were reshaped using the reshape2 package to melt the data frame to one, 
long frame with subject and activity as identifiers, and all other columns as variables.
This allows the long data frame to be recast using dcast to summarize the data by subject
and activity, presenting the mean of all available data for each subject/activity 
combination, and the resulting small, tidy data set was output to "tidy_small.txt".

## Variable descriptions

Complete descriptions of the source files and the data they contain are included in the .zip 
archive, and herein by reference. It is worth noting that specific units for the values
included in the feature vectors were not provided.  Feature names indicate the type of data,
with 'acc' indicating the data are linear acceleration along a specified axis (X, Y, or Z),
and 'gyro' for angular velocity measurements (also from a specified axis, X, Y, or Z).  The 
feature data as provided were all normalized and bounded by [-1, 1].

The variables included in the tidy_small.txt file include:
* subject - the subject identifier, an integer between 1 and 30 provided with the source
indicating which individual test subject the data are associated with.
* activity - the name of the activity from which the data were collected
* 66 feature variables - data included are __means__ of the source data for each variable name/subject/activity combination, per project instructions.

