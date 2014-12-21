#Project readme file
## Summary
The goal of this project was to create a tidy data set from the initial dataset provided
The dataset loaded here is tidy because each column represents one variable only and each row represents one observation only. 
The dataset submitted consistes of 180 rows and 81 columns
Columns are as follows:
. Column 1 - SubjectID - the ID of the subject
. Column 2 - ActivityID - the name of the ActivityID
. Columns 3 through 81 - AVG (featurename) - columns 3 through 81 of the dataset are the averages of the features extracted from the initial datasets
## Getting data
For this project the file was downloaded and unzipped manually into a local folder and then read from there. 
Code comments outline how each portion of the project was executed. Summarized here
### Define paths to read
defined variables for where data are stored

### Identifying which columns to read
used grep to figure out which feature labels to read. A point to note here is that the use of the "()" in the feature labels created problems
summarizing later on in the code so I manually found and replaced all "()" in the feature label set with a "_". This was also because gsub 
within the R code wasn't able to replace the "()" either and I didn't have time to research any more. 
after reading the feature labels, two headers for activity and subject id were added. this will be used later on in the code to add readable headers.
It should also be noted that since the grep search was for "mean" and "std" only, there may be some non-mean, non-stdev features that could get picked up
It does not violate the principles of tidy data though.  

### Reading the data
Read through read.table using colNames identified by the previous section. The important point to note here is that headers must be false because we'll add 
the right headers later. 

## Adding readable column names
After reading in the header names from the subject labels and activity labels files, names() was used to replace headers for all columns
when the feature labels were being read, two extra headers for subject id and activity id were added. 

## replacing activity ids with labels
The next part of this exercise is to take the activity ids and replace them with labels read from the activity labels file. 
the plyr package was used for this purpose. the revalue function replaces values. To be noted here is that since the activity labels were small,
I hard coded the values transformations in the revalue function. 

## Merging the two datasets (train and test)
Once both datasets are read in, merge is simply rbind.Subject ID and Activity ID are column bound. 

## Summarizing.
the sqldf package was used to summarize averages of features chosen by subject by activity. the code dynamically creates a sql string to pass for 
every feature column and binds the result to the final dataset

## writing to file
write.table was used to write the finally assembled (now tidy) dataset to a text file called TidyResults.txt. 





