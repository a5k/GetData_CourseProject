#Codebook for results submitted

## Summary
The goal of this project was to create a tidy data set from the initial dataset provided
The dataset loaded here is tidy because each column represents one variable only and each row represents one observation only
and follows the principles of tidy datasets as listed [here](http://vita.had.co.nz/papers/tidy-data.pdf)


The dataset submitted  is a **wide** tidy dataset that of *180 rows* and *68 columns*. 

Columns are as follows:
* Column 1 - SubjectID - the ID of the subject. 
* Column 2 - ActivityID - the name of the Activity conducted (e.g. WALKING, STANDING etc)
* Columns 3 through 68 - AVG of <featurename> - columns 3 through 68 of the dataset are the averages of the means and standard deviations of features extracted from the initial datasets

The submitted tidy dataset can be read in using read.table("./TidyDataSet.txt", header = TRUE) to yield a 180 X 68 data frame. 

## Instructions for analysis
Instructions for how the raw data were collected, filtered, and shaped to result in the submitted tidy dataset are presented below

### Getting Data
For this project the file was downloaded and unzipped manually into a local folder and then read from there using read.table. 
Since the data read were raw data, no headers were read. Columns were limited by the logic outlined in section "Identifying which columns to read"

### Define paths to read
Local paths (on local machine) were defined. The analysis script will assume that the paths are valid. Please see the source R file for the exact patch specified

### Cleaning feature lables for use
Feature labels presented in the raw data contain "()" and "-" characters which can create errors with shaping and summarizing functions. 
So the first task was to replace the "()" and the "-" characters with "_". Additionally, for ease of reading, labels starting with "f" were changed to 
start with "Freq_" to mark features of type frequency. Similarly, labels starting with "t" were changed to start with "Time_" to mark features of type
time. 

### Identifying which columns to read
Once feature labels were cleaned, getrep to figure out which feature labels to read. Since the requirement is to create a tidy dataset of means of observations
of means and standard deviations, only features that matched the pattern "mean_" and "std_" were chosen. This resulted in 66 features that needed to selected. 
It should be noted that some feature labels containing "...meanFreq..." were not selected because they were assumed to not be a mean or standard deviation measurement. 

After reading the feature labels, two headers for activity and subject id were added. These will be used later on in the code to add readable headers.
 

### Reading the data
Read through read.table using colNames identified by the previous section. The important point to note here is that headers must be set to false because we'll add 
the right headers later. 

### Adding readable column names
After reading in the header names from the subject labels and activity labels files, names() was used to replace headers for all columns
when the feature labels were being read, two extra headers for subject id and activity id were added. 

### replacing activity ids with labels
The next part of this exercise is to take the activity ids and replace them with labels read from the activity labels file. 
The plyr package was used for this purpose. the revalue function replaces values. 

### Merging the two datasets (train and test)
Once both datasets are read in, merge is simply rbind. Subject ID and Activity ID are column bound prior to row binding the test and train dataset.  

### Summarizing.
The sqldf package was used to summarize averages of features chosen by subject by activity. The code dynamically creates a sql string to pass for 
every feature column and column binds the result to the final dataset. 

### writing to file
write.table was used to write the finally assembled (now tidy) dataset to a text file called TidyDataSet.txt. Headers were set to TRUE while using write.table.

## Observation identifiers
 [1] "SubjectID" - ID of the subject of type numeric. Contains values between 1 and 30.   
 [2] "ActivityID" - name of the activity subject was measured for of type character. Six possible values of this variable exist 
 STANDING, WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, LAYING
 
 
 Columns 3 through 68 in the results are the means of all the observations of the mean and standard deviation of the following features by subject id and activity

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Means are denoted by "_mean" in text. Standard deviation is denoted by "_std" in text 

Columns headers 3 through 68 are listed below. They are all of type numeric. 

  [3] "AVG( Time_BodyAcc_mean___X )"          
 [4] "AVG( Time_BodyAcc_mean___Y )"          
 [5] "AVG( Time_BodyAcc_mean___Z )"          
 [6] "AVG( Time_BodyAcc_std___X )"           
 [7] "AVG( Time_BodyAcc_std___Y )"           
 [8] "AVG( Time_BodyAcc_std___Z )"           
 [9] "AVG( Time_GravityAcc_mean___X )"       
[10] "AVG( Time_GravityAcc_mean___Y )"       
[11] "AVG( Time_GravityAcc_mean___Z )"       
[12] "AVG( Time_GravityAcc_std___X )"        
[13] "AVG( Time_GravityAcc_std___Y )"        
[14] "AVG( Time_GravityAcc_std___Z )"        
[15] "AVG( Time_BodyAccJerk_mean___X )"      
[16] "AVG( Time_BodyAccJerk_mean___Y )"      
[17] "AVG( Time_BodyAccJerk_mean___Z )"      
[18] "AVG( Time_BodyAccJerk_std___X )"       
[19] "AVG( Time_BodyAccJerk_std___Y )"       
[20] "AVG( Time_BodyAccJerk_std___Z )"       
[21] "AVG( Time_BodyGyro_mean___X )"         
[22] "AVG( Time_BodyGyro_mean___Y )"         
[23] "AVG( Time_BodyGyro_mean___Z )"         
[24] "AVG( Time_BodyGyro_std___X )"          
[25] "AVG( Time_BodyGyro_std___Y )"          
[26] "AVG( Time_BodyGyro_std___Z )"          
[27] "AVG( Time_BodyGyroJerk_mean___X )"     
[28] "AVG( Time_BodyGyroJerk_mean___Y )"     
[29] "AVG( Time_BodyGyroJerk_mean___Z )"     
[30] "AVG( Time_BodyGyroJerk_std___X )"      
[31] "AVG( Time_BodyGyroJerk_std___Y )"      
[32] "AVG( Time_BodyGyroJerk_std___Z )"      
[33] "AVG( Time_BodyAccMag_mean__ )"         
[34] "AVG( Time_BodyAccMag_std__ )"          
[35] "AVG( Time_GravityAccMag_mean__ )"      
[36] "AVG( Time_GravityAccMag_std__ )"       
[37] "AVG( Time_BodyAccJerkMag_mean__ )"     
[38] "AVG( Time_BodyAccJerkMag_std__ )"      
[39] "AVG( Time_BodyGyroMag_mean__ )"        
[40] "AVG( Time_BodyGyroMag_std__ )"         
[41] "AVG( Time_BodyGyroJerkMag_mean__ )"    
[42] "AVG( Time_BodyGyroJerkMag_std__ )"     
[43] "AVG( Freq_BodyAcc_mean___X )"          
[44] "AVG( Freq_BodyAcc_mean___Y )"          
[45] "AVG( Freq_BodyAcc_mean___Z )"          
[46] "AVG( Freq_BodyAcc_std___X )"           
[47] "AVG( Freq_BodyAcc_std___Y )"           
[48] "AVG( Freq_BodyAcc_std___Z )"           
[49] "AVG( Freq_BodyAccJerk_mean___X )"      
[50] "AVG( Freq_BodyAccJerk_mean___Y )"      
[51] "AVG( Freq_BodyAccJerk_mean___Z )"      
[52] "AVG( Freq_BodyAccJerk_std___X )"       
[53] "AVG( Freq_BodyAccJerk_std___Y )"       
[54] "AVG( Freq_BodyAccJerk_std___Z )"       
[55] "AVG( Freq_BodyGyro_mean___X )"         
[56] "AVG( Freq_BodyGyro_mean___Y )"         
[57] "AVG( Freq_BodyGyro_mean___Z )"         
[58] "AVG( Freq_BodyGyro_std___X )"          
[59] "AVG( Freq_BodyGyro_std___Y )"          
[60] "AVG( Freq_BodyGyro_std___Z )"          
[61] "AVG( Freq_BodyAccMag_mean__ )"         
[62] "AVG( Freq_BodyAccMag_std__ )"          
[63] "AVG( Freq_BodyBodyAccJerkMag_mean__ )" 
[64] "AVG( Freq_BodyBodyAccJerkMag_std__ )"  
[65] "AVG( Freq_BodyBodyGyroMag_mean__ )"    
[66] "AVG( Freq_BodyBodyGyroMag_std__ )"     
[67] "AVG( Freq_BodyBodyGyroJerkMag_mean__ )"
[68] "AVG( Freq_BodyBodyGyroJerkMag_std__ )

