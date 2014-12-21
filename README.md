#Project README File
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

## Adding readable column names
After reading in the header names from the subject labels and activity labels files, names() was used to replace headers for all columns
when the feature labels were being read, two extra headers for subject id and activity id were added. 

## replacing activity ids with labels
The next part of this exercise is to take the activity ids and replace them with labels read from the activity labels file. 
The plyr package was used for this purpose. the revalue function replaces values. 

## Merging the two datasets (train and test)
Once both datasets are read in, merge is simply rbind. Subject ID and Activity ID are column bound prior to row binding the test and train dataset.  

## Summarizing.
The sqldf package was used to summarize averages of features chosen by subject by activity. The code dynamically creates a sql string to pass for 
every feature column and column binds the result to the final dataset. 

## writing to file
write.table was used to write the finally assembled (now tidy) dataset to a text file called TidyDataSet.txt. Headers were set to TRUE while using write.table. 






