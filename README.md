---
title: "README"
---

---
title: "README"
---
This file contains the script performing the analysis and comments for it. The script requires that the raw data files are downloaded from here <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> and the folder "UCI HAR Dataset" is extracted to the same folder where script R-file is. The script uses only the R base functions -> no package installations needed.  
First read the necessary data into R. Note that there are also such files in the data folder which are not needed.

```{r}
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
```
Next the script merges the data in X_train and X_test into one data frame X_merged using column binding (cbind). This is possible because the both have the same variables in the columns in same order. This was the first task. After this the columns are named after the feature names in "features" second column. This was the fourth task but it's carried out here because it's the easiest since "features" has the variable names in the same order as in X_merged.
```{r}
X_merged<-rbind(X_train,X_test)
colnames(X_merged)<-features[,2]
```
The second task was to erase the variables which don't include a mean or a standard deviation (std).
The indices of those columns are the row numbers of the corresponding elements in "features". The indices were chosen by looking at the elements.
```{r}
X_merged[c(7:40,47:80,87:120,127:160,167:200,
		203:213,216:226,229:239,242:252,
		255:265,272:293,297:344,351:372,
		376:423,430:451,455:502,505:515,
		518:525,527:528,531:538,540:541,
		544:551,553:561)]<-list(NULL)
```
The third task was to use descriptive activity names. First the activity names from y_train and y_test, in this order because X_train and X_test were merged in the same order. Using rbind inside cbind to bind y_train and y_test as one column.
```{r}
X_merged<-cbind(rbind(y_train,y_test),X_merged)
```
Then this column is made a factor to make it easier to change the numbers to matching labels found in activity_labels and the levels are replaced by the levels in activity_labels which turns the elements in this column as factor variables with descriptive names like "WALKING". The column is also renamed as "Activity".
```{r}
X_merged[,1]<-factor(X_merged[,1])
levels(X_merged[,1])<-as.factor(activity_labels[,2])
colnames(X_merged)[1]<-"Activity"
```
Next, the subject numbers are added as a new column:
```{r}
X_merged<-cbind(rbind(subject_train,subject_test),X_merged)
colnames(X_merged)[1]<-"Subject#"
X_merged[,1]<-factor(X_merged[,1])
```
Next construct an empty data frame for the averages for different activities for different test subjects (Task 5). It is known that there are 6 different activities and 30 different test subjects, so the number of observations for these is 30 times 6 which equals 180, therefore 180 rows are needed. Number of columns is the number of different measurements that include mean or standard deviation i.e. the number of columns in X_merged. (columns for the subject numbers and activity labels are needed as well)  

First is needed a vector with each of the subject numbers six times, because there are six activies for each subject. A function needs to be constructed because sApply is used.
```{r}
rep_times <- function(x,times){rep(x,times)}
subject_rep<-sapply(unique(X_merged$Subject),rep_times,times=6)
```
This returns a matrix and it can be transformed as vector using sapply with rbind.
```{r}
Subject<-sapply(subject_rep,rbind)
```
Also a vector that contains the activity labels 30 times is needed. (for each subject, we want each activity once. these are found for example in the levels of Activity column of the previous data frame.
```{r}
Activity<-rep(levels(X_merged$Activity),30)
```
Now a new data frame is constructed from these vectors (the numberical data is added step by step later.
```{r}
X_average<-data.frame(Subject, Activity)
```
Then build a data frame into which we calculate the averages of the different variables for different subjects for different activities (subract two from the column number because columns for Activity and Subject aren't neede):
```{r}
averages<-data.frame(matrix(NA, nrow = 180, ncol = (ncol(X_merged)-2)))
```
The averages for different subjects for different activities is calculated using two nested for loops. The outer(first) for loops through the different subject numbers. The second one loops through the different activities. Inside the second loop averages are put on separate rows. The indexing is made running from 1 to 180. Column means are calculated for a subsetted data and these form a row for the new data frame "averages". The subsetting chooses all combinations of subjects and activities so that each subject has each activity
once. Column means are calculated for columns which include the measurements in X_merged for the chosen rows.
```{r}
for (i in 1:length(unique(X_merged$Subject))){
	for (j in 1:length(unique(X_merged$Activity))){
		averages[j+(i-1)*6,]<-colMeans(X_merged[X_merged$Subject==unique(X_average$Subject)[i] &
						X_merged$Activity==unique(X_average$Activity)[j],][,3:ncol(X_merged)], na.rm=TRUE)
	}
}
```
Column names for the measurements are copied from the first data frame and a string "Average:" is added to make the variables more descriptive.
```{r}
colnames(averages)<-colnames(X_merged)[3:80]
colnames(averages)<-paste("Average:",colnames(X_merged)[3:80])
```
And at last, the data frame with the activities and subjects is bound to the data frame with the averages for the measurements. NOTE: this is possible because the for loops above calculate the activity and subject averages in the same order as they appear in X_averages.
```{r}
X_average<-cbind(X_average,averages)
```
The resulting data frame has 180 rows with unique Subject-Activity combinations and the numberical columns contain the averages for those combinations from the data frame that was built in tasks 1-4.  

This last function is used to write X_average into a text file:
```{r}
write.table(X_average,"X_average.txt")
```
