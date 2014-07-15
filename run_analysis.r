
# This code downloads data from the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/index.html) 
# and creates a tidy dataset reporting means for each variabel within respective combinations of activities for 
# subjects carrying a Samsung smartphne.

setInternet2(TRUE)
install.packages("plyr")
library(plyr)

## Create directory if not present and download dataset
dataset = function() {
	if (!file.exists("data")) {dir.create("data")}
	if (!file.exists("data/UCI HAR Dataset")) {
		source <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
		file="data/UCI_HAR_data.zip"
		download.file(source, destfile=file, method="curl")
		unzip(file, exdir="data")}}

## Merges test and training sets
merge = function() {
	training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
	training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
	training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
	test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
	test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
	test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
	merged.x <- rbind(training.x, test.x)
	merged.y <- rbind(training.y, test.y)
	merged.subject <- rbind(training.subject, test.subject)
	list(x=merged.x, y=merged.y, subject=merged.subject)}

## Obtains mean and standard deviation for X values
calculate = function(df) {
	features <- read.table("data/UCI HAR Dataset/features.txt")
	mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
	std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
	edf <- df[, (mean.col | std.col)]
	colnames(edf) <- features[(mean.col | std.col), 2]
	edf}

## Provides activity names
name = function(df) {
	colnames(df) <- "activity"
	df$activity[df$activity == 1] = "WALKING"
	df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
	df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
	df$activity[df$activity == 4] = "SITTING"
	df$activity[df$activity == 5] = "STANDING"
	df$activity[df$activity == 6] = "LAYING"
	df}

## Merges mean and standard deviations with activities
bind.data <- function(x, y, subjects) {
	cbind(x, y, subjects)}

## Creates tidy dataset
maketidy = function(df) {
	tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
	tidy}

## Downloads data, merges training and test data, returns means and standard deviations, 
## names activities, creates tidy dataset and exports results as "tidy.csv"
cleandata = function() {
	dataset()
	merged <- merge()
	cx <- calculate(merged$x)
	cy <- name(merged$y)
	colnames(merged$subject) <- c("subject")
	combined <- bind.data(cx, cy, merged$subject)
	tidy <- maketidy(combined)
	write.csv(tidy, "tidy.csv", row.names=FALSE)}
