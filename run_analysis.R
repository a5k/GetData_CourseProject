##assumes all data have been downloaded and unzipped

######################################################
## Define paths

path<-"../getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset"

path_train <- file.path(path, "train")
path_test <- file.path(path, "test")

file_test_activityid <- "y_test.txt"
file_test_data <- "X_test.txt"
subject_test <- "subject_test.txt"

file_train_activityid <- "y_train.txt"
file_train_data <- "X_train.txt"
subject_train <- "subject_train.txt"


activity_labels <- "activity_labels.txt"
feature_labels <- "features.txt"

########################################################

######################################################
##Identify features to select. no headers in files

feature_labels <- read.table(file.path(path, feature_labels),
                             header = FALSE)
activity_labels <- read.table(file.path(path, activity_labels), 
                              header = FALSE)

## find all columns in feature labels that contain a mean
col_mean <- grep("mean", feature_labels$V2)

## find all columns in feature labels containing a stdev
col_std <- grep("std", feature_labels$V2)

##create the columns vector that contains features of interest
cols <- sort(c(col_mean, col_std))
col_names <- feature_labels[cols,]
col_names <- as.character(col_names$V2)
##add names for activityid and subjectid
col_names <- c(col_names, "ActivityID", "SubjectID")
##replace all "-" with "_" and () with "_"
## I was unable to remove "()" from the feature name in R
## so did a find/replace in Notepad++ to replace all "()" 
##with "_". the "()" interferes with sqldf operations. 
col_names <- gsub("-","_", col_names)
#col_names <- gsub("()", "_", col_names)
##create a column list vector of nulls
col_list <- rep("NULL", nrow(feature_labels))
## replace NULL with NA for the columns we need
col_list[cols] <- NA

#########################################################

##Reading in measurements, activity labels and subject id
##raw measurements are in data_test
##subject id is in subject_test
##activity id is in activityid_test
##subject id is in subjectid_test
## add a column to data_test showing activity type 
## activity type is read from y_test

activityid_test <- read.table(file.path(path_test, file_test_activityid), 
                          header = FALSE)
activityid_train <- read.table(file.path(path_train, file_train_activityid),
                               header = FALSE)

data_test <- read.table(file.path(path_test, file_test_data), 
                        header = FALSE,
                        colClasses = col_list)

data_train <- read.table(file.path(path_train, file_train_data),
                         header = FALSE,
                         colClasses = col_list)


subjectid_test <- read.table(file.path(path_test, subject_test),
                             header = FALSE)

subjectid_train <- read.table(file.path(path_train, subject_train),
                              header = FALSE)


###################################################################

##################################################################
## tidying up test raw file
##add a column for the activity id for each measurement
data_test <- cbind(data_test, activityid_test)
data_train <- cbind(data_train, activityid_train)

##now add a column identifying the subject id for each measurement
data_test <- cbind(data_test, subjectid_test)
data_train <- cbind(data_train, subjectid_train)

## rename column names 
names(data_test) <- col_names
names(data_train) <- col_names

## replace activity id with activity labels
## we will use the revalue function from the plyr package
library(plyr)
##convert ACtivityID to character
data_test$ActivityID <- as.character(data_test$ActivityID)
data_train$ActivityID <- as.character(data_train$ActivityID)
##now revalue based on labels in activity_labels. 
##since we have a small number of labels we will recode manually
data_test$ActivityID <- revalue(data_test$ActivityID,
                                c("1" = "WALKING",
                                  "2" = "WALKING_UPSTAIRS",
                                  "3" = "WALKING_DOWNSTAIRS",
                                  "4" = "SITTING",
                                  "5" = "STANDING",
                                  "6" = "LAYING"))

data_train$ActivityID <- revalue(data_train$ActivityID,
                                c("1" = "WALKING",
                                  "2" = "WALKING_UPSTAIRS",
                                  "3" = "WALKING_DOWNSTAIRS",
                                  "4" = "SITTING",
                                  "5" = "STANDING",
                                  "6" = "LAYING"))
###################################################################
##merge the two sets into one 

data <- rbind(data_test, data_train)

################################################################
## now we simply use SQL summary functions to find the 
## average of each feature by subjectid, by activity

library(sqldf)
## create the first result column
col_str <- paste("AVG(", col_names[1], ")")

SQLstr <- paste("select SubjectID, ActivityID, ", col_str, " from data
                 group by SubjectID, ActivityID")

Result <- sqldf(SQLstr)

## loop through remaining column names 
##except for last two column names
for (i in 2:(length(col_names)-2)){
  ##create the col str
  col_str <- paste("AVG(", col_names[i], ")")
  
  SQLstr <- paste("select SubjectID, ActivityID, ", col_str, " from data
                 group by SubjectID, ActivityID")
  
  temp <- sqldf(SQLstr)
  ## we are interested in only the average column
  Result <- cbind(Result, temp[,3])
  
}

## create the header names
for (i in 1:(length(col_names)-2)){
  ##create the col str
  col_str[i] <- paste("AVG(", col_names[i], ")")
}

col_str <- c("SubjectID", "ActivityID", col_str)

names(Result) <- col_str
#######################################################################3
##write the result to a table

write.table(Result, "./TidyDataSet.txt", row.name = FALSE, 
            col.names = TRUE)


