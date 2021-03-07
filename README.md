# run_analysis

The code is built up as follows:

first, the zipfile is downloaded and unzipped. Each relevant file is assigned to a variable to work with read_table.

Then, the colums of mean and standard deviation are filtered. This happens with the grepl function, where every mean() and std() is looked for.

The Subject and Activity columns are renamed to descriptive values with according files of the zip-file in a for loop.

To merge the data, first the test and training data are merged with cbind(). Afterwards, both files are merged with rbind(), because they are built up likewise, only with a different number of rows.

The column names are renamed with a for-loop. Every name has a number, which can be looked up in the file features.txt.


Finally, the mean values of each subject and activity are calculated and written into a seperate .txt file

Code Book:

activityLabel, features, trainSubject, trainY, trainX, testY, testX, testSubject ----- all tables of origin data files
testXfiltered, trainXfilteres, meanvector, stdvector, v1vector ----- variables used for filtering mean() and std()
trainData, testData ----- merged train and test data set
mergedData ---- merged data set
newdf ---- new data frame for the final data set of mean values
