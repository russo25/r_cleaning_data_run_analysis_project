## 1. Import  dplyr library

library(dplyr)

## 2. Read in  X test data sets
    x.test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)

## 3. Read in the test labels
    y.test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)

## 4. Read test subject data sets
    subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

## 5. Merge  test data sets into a single dataframe
    test <- data.frame(subject_test, y.test, x.test)

## 6. Read in  X training data sets
    x.train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)

## 7. Read in the training labels
    y.train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)

## 8. Read in the training subject data sets
    subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

## 9.  Merge test and training data sets into single dataframe
    tng <- data.frame(subject_train, y.train, x.train)

## 10. Combine the training and testing  datasets
    run.data <- rbind(tng, test)

## 11. Remove  files not needed any longer

    remove(subject_test, x.test, y.test, subject_train, x.train, y.train, test, tng)

## 12. Read in the measurement labels data sets

    features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
    
## 13. Convert column number 2 to vector
    
    column.names <- as.vector(features[, 2])
    
## 14. Apply  measurement labels as column names combined data sets
    colnames(run.data) <- c("subject_id", "activity_labels", column.names)

## 15. Chose only  columns with mean or standard dev., and
## exclude columns with frequency and angle in their name
    
    run.data <- select(run.data, contains("subject"), contains("label"),
                   contains("mean"), contains("std"), -contains("freq"),-contains("angle"))

## 16. Read in the activity labels data sets
    
    activity.labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

## 17. Replace  activity codes in the smaller data sest with  labels  the activity labels data sets.
    
    run.data$activity_labels <- as.character(activity.labels[
                  match(run.data$activity_labels, activity.labels$V1), 'V2'])

## 18. Clean column names, and remove parantheses and hyphens
## Correct columns that repeat the word "Body".
    
    setnames(run.data, colnames(run.data), gsub("\\(\\)", "", colnames(run.data)))
    setnames(run.data, colnames(run.data), gsub("-", "_", colnames(run.data)))
    setnames(run.data, colnames(run.data), gsub("BodyBody", "Body", colnames(run.data)))
    
## 19.  Group the running data by subject & acty, and calculate all means
    
    run.data.summary <- run.data %>%
                  group_by(subject_id, activity_labels) %>%
                  summarize_each(funs(mean))

## 20. Write run.data to a file
    write.table(run.data.summary, file="run_data_summary.txt", row.name=FALSE)