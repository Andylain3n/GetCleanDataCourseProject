---
title: "CodeBook"
---

##Raw data

The raw data was the "Human Activity Recognition Using Smartphones Data Set" downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.  The full description of the data set used in this analysis is found here: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.  
The numerical data contains measurements from a mobile phone's embedded accelerometer and gyroscope. 30 people (test subjects/subjects) carried out six different activities while wearing a mobile phone on their waists. The people were divided into two sets called the train and the test set. 70% of the people were in the train set and 30% in the test set. The numerical data are found in X_train.txt and X_test.txt. 
The data were read into R data frames from txt files with corresponding names:  
  
* X_train: Numerical data for the test subjects in the train set.   
* X_test: Numberical data for the test subjects in the test set.  
* subject_train: The train set subject numbers in the same row order as the observations in X_train.   
* subject_test: The test set subject numbers in the same row order as the observations in X_test.  
* features: Labels for the variables (column names) in X_train and in X_test  
* y_train: Activity numbers in the same row order as the obervations in X_train.  
* y_test: Activity numbers in the same row order as the obervations in X_test.  
* activity_labels: Activity numbers with matching activity names.  
  
The X_train and X_test are read into data frames that have variables in columns in the corresponding order that they appear in the features (single column data frame). y_train and y_test (single column data frames) contain the numbers for different activities. Those (unique) numbers appear in the data frame activity_labels which has a number and a corresponding string indicating the activity. y_train and y_test are ordered to tell which activity the observations on X_train and X_test are related to. Similarly, subject_train and subject_test are ordered to tell which person the  observations on X_train and X_test are related to.

##Variables

The information about the variables in raw data (X_test and X_train) is found in the data set folder in a text file "features_info.txt". Here's a quotation describing the variables from that file:

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

>tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  

>The set of variables that were estimated from these signals are: 

>mean(): Mean value  
std(): Standard deviation  
mad(): Median absolute deviation   
max(): Largest value in array  
min(): Smallest value in array  
sma(): Signal magnitude area  
energy(): Energy measure. Sum of the squares   divided by the number of values.  
iqr(): Interquartile range  
entropy(): Signal entropy  
arCoeff(): Autorregresion coefficients with Burg order equal to 4  
correlation(): correlation coefficient between two signals  
maxInds(): index of the frequency component with largest magnitude  
meanFreq(): Weighted average of the frequency components to obtain a mean frequency  
skewness(): skewness of the frequency domain signal   
kurtosis(): kurtosis of the frequency domain signal   
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.  
angle(): Angle between to vectors.  

>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:  

>gravityMean  
tBodyAccMean  
tBodyAccJerkMean  
tBodyGyroMean  
tBodyGyroJerkMean  
  
##Data Processing

The raw data was in multiple files. Those files were read into R as data frames and transformed into one data frame. First the X_train and X_test were merged into one data frame X_merged by adding the rows of X_test at the bottom of X_train. The columns were named using the elements in features. Then the rows of y_train and y_test were inserted to X_merged as a new column in the corresponding order as X_merged was built. Then the same was done with the elements of the subject vectors.  
Next, the columns of X_merged which didn't include mean or standard deviation of a measure, were erased.  
After that, the column with the activity numbers was factorized, and the levels of this factor column were replaced with the corresponding labels from the activity_labels data frame which had the coding from a number to a string class label.  
And last, another data frame was created with unique subject-activity combinations, having one line for each subject-activity pair. Then, using for loops and subsetting, averages for each varibable for each subject-activity combination were calculated from those observations in X_merged where the specific subjects and activities matched. These were moved to the data frame with the unique subject-activity combinations. Finally, the columns of the data frame were named in a describing the contents.
