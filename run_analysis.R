#!/usr/bin/R
#
# This script to be run from the base directory for the unzipped "dirty" data.
# setwd(Sys.getenv("GCDATA"))
#
# This script tries to adhere to the Google R coding conventions:
#
# https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
#
###############################################################################
# PROJECT STATEMENT:
###############################################################################
#
# The purpose of this project is to demonstrate your ability to collect, work
# with, and clean a data set. The goal is to prepare tidy data that can be used
# for later analysis. You will be graded by your peers on a series of yes/no
# questions related to the project. You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
# 
# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected
# from the accelerometers from the Samsung Galaxy S smartphone. A full
# description is available at the site where the data was obtained:
# 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set. 
#
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement.
#
# 3. Uses descriptive activity names to name the activities in the data set 
#
# 4. Appropriately labels the data set with descriptive variable names.
#
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
# 

###############################################################################
# libraries, sources
###############################################################################
library(dplyr)
library(reshape2)

###############################################################################
# Execution switches
###############################################################################
debug <- TRUE
debug <- FALSE  # Uncomment for the final version

###############################################################################
# Statements
###############################################################################
# 1.- Merges the training and the test sets to create one data set.
###############################################################################
cat("1. Merging the training and test sets...\n")
#
# 1.a) Assign names to the measurement columns: these are preliminary, pending making them meaningful
#
featuresFile <- "UCI\ HAR\ Dataset/features.txt"
features <- read.table(featuresFile, col.names=c("idx","names"), as.is=c(2))  # Comes up as a two-column table: the second is the interesting one.
# as.is reads the second column in character format,e.g. strings, since we are using them as variables later.
if (debug){
    str(features)    
}
#featureNames <- featuresFrame[, 2]
if (debug) {
    features$names  # Explore the variable names
#    str(featureNames)
}
# CAVEAT: as per the requirements for tidy data, these variable names are dreadful! We'll massage them in no. 4
#
# 1.b) Read test measurements
#
cat("Loading the test dataframe...\n")
testXFile <- "UCI\ HAR\ Dataset/test/X_test.txt"
testX <- read.table(testXFile, col.names=features$names)
if (debug){
    dim(testX)
}
# Read test subject data
testSubjectsFile <- "UCI\ HAR\ Dataset/test/subject_test.txt"
testSubjects <- read.table(testSubjectsFile, col.names=c("subject"), colClasses=c("factor"))
# The subjects are really a factor: there is nothing special in the integers
if (debug){
    str(testSubjects)    
}
# Read test label data (activity codes)
testYFile <- "UCI\ HAR\ Dataset/test/y_test.txt"
testY <- read.table(testYFile, col.names=c("act_code"))  # Key for the join later on.
if (debug){
    str(testY)    
}
# Put together the test set: by using variable names we guarantee that the bind is meaningful!
testSet <- cbind(testY,testSubjects,testX)
if (debug){
    str(testSet)    
}
# Now repeat on the training set: read measurements...
cat("Loading the train dataframe...")
trainXFile <- "UCI\ HAR\ Dataset/train/X_train.txt"
trainX <- read.table(trainXFile, col.names=features$names)
if (debug) {
    str(trainX)
}
# Read train subject data...
trainSubjectsFile <- "UCI\ HAR\ Dataset/train/subject_train.txt\n"
trainSubjects <- read.table(trainSubjectsFile, col.names=c("subject"), colClasses=c("factor"))
# The subjects are really a factor: there is nothing special in the integers
if (debug){
    dim(trainSubjects)    
}
# Read train label data (activity codes).
trainYFile <- "UCI\ HAR\ Dataset/train/y_train.txt"
trainY <- read.table(trainYFile, col.names=c("act_code"))  # Meant to disappear in the join 
if (debug){
    dim(trainY)    
}
# Put together the train set
trainSet <- cbind(trainY, trainSubjects, trainX)
if (debug){
    dim(trainSet)    
}
# Now put together the whole data!!
df <- rbind(trainSet, testSet)
# For the record: First 7352 is the train set, next 2947 is the test set
if (debug){
    str(df)    
}
# For the final script, do some clearance: keep only the "raw" train/test split
if (!debug){
    remove(list=c("trainY", "trainSubjects", "trainX", 
                  "testY", "testSubjects", "testX"))
}
##############################################################################################
# 2.- Extracts only the measurements on the mean and standard deviation for each measurement.
# Solution: Use select with matches on mean and std!
##############################################################################################
# Decision #1: We only select those measurements which have mean and std components calculated. 
cat("2. Extracting the mean and standard deviations for measurements that have both...\n")
dfSelected <- select(df, act_code,subject, matches("mean|std",ignore.case=FALSE))  # Some vars have CamelCase names.
if (debug){
    str(dfSelected)
}

##############################################################################################
# 3.- Uses descriptive activity names to name the activities in the data set
##############################################################################################
cat("3. Providing descriptive names for the activities...\n")
# Load the activities table
activitiesFile <- "UCI\ HAR\ Dataset/activity_labels.txt"
dfActivities <- read.table(activitiesFile, col.names=c("code", "activity"))
if (debug){
    print(dfActivities)  # Small enough that we can view it all.   
}
# Do the natural join with the selected df, then forget the act_code variable
dfSelected <- select(merge(dfActivities, dfSelected, by.x="code", by.y="act_code"), -code)
#Code is already meaningful in dfActivities, and we can use "activity" as the common key now.
if (debug){
    str(dfSelected)
}

##############################################################################################
# 4.- Appropriately labels the data set with descriptive variable names. 
# "appropriately" is here taken to mean:
# 1) Use lowercase (slide in week 4 )
# 2) Do not use "dots" in names
##############################################################################################
cat("4. Relabelling the variables (using camelCase for this instances due to label complexity).\n")
dfm <- melt(dfSelected, id=c("activity","subject"))
# Now the "variable colum" has id variables encoded in the name of vars, and we should be melting them
# but the statement only requires to supply readable names.
# I am going to use camelCase although the rules for tidy data would seem not to allow it, because:
# - lowercase is rather unreadable in this case.
# - the names are rather descriptive already, if with abbreviations
newNames <- names(dfSelected)
# Expand f to "frequency", initial "t" to "time"
newNames <- sub("^t", "time",newNames)
newNames <- sub("^f", "frequency",newNames)
# Expand "Acc" into "Accelerator", "Gyro" into "Gyroscope"
newNames <- sub("Acc","Accelerator",newNames)
newNames <- sub("Gyro", "Gyroscope",newNames)
# Dots with "mean" and "std" dissapear. They adopt camlCase
# Freq seems to be redundant when appearing
newNames <- sub("\\.mean(Freq)?", "Mean",newNames)
newNames <- sub("\\.std?", "Std",newNames)  # Std, is an acceptable abbreviation
# Axis specification are universally understood: X, Y and Z: We just dispose of ... before them
newNames <- sub("\\.\\.(\\.)?","",newNames)
# Magnitude is derived from X, Y, Z coordinates so it should be in the same "slot"
# And we prefer the specification of the measures first, then the aggregate operation, e.g. XMean or XStd
# instead of MeanX, StdX
newNames <- sub("(Mean|Std)(X|Y|Z)", "\\2\\1",newNames)
# Finally rename with the new names
colnames(dfSelected) <- newNames
if (debug){
    all(names(dfSelected) == newNames)
}
##############################################################################################
# 5.- From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
##############################################################################################
cat("5. Creating tidy dataset to be uploaded in project page...\n")
# Here's where it pays to have activities and subjects as factors.
# library(plyr)
# tidy <- tapply(dfSelected,dfSelected$activity, mean)
# tidy <- ddply(dfSelected,.(activity,subject), c("mean"), drop=FALSE)
# tidy <- aggregate(dfSelected, by=list(dfSelected$activity, dfSelected$subject), mean)
tidy <- aggregate( . ~ activity + subject, dfSelected, mean)
if (debug){
    str(tidy)
    head(tidy)
}
cat("Producing uploadable textual version of the data frame to ./tidy.txt  ...\n")
write.table(tidy,"./tidy.txt",row.name=FALSE)
cat("This can be read with: newTidy <- read.table(\"./tidy.txt\")\ns")