##Getting and cleaning data
##Project Assignment 1

##reading the data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

##Merging the test and train data:
X_merged<-rbind(X_train,X_test)##first rows from X_train, then X_test

##Replasing the column names with the labels given in "features":
colnames(X_merged)<-features[,2]

##Next erasing those columns which don't include mean or standard deviation
##(The columns to be erased are chosen by the column names

##columns that don't include mean or standard deviation: 
##7-40, 47-80, 87-120, 127-160, 167-200, 203-213, 216-226, 229-239, 242-252
##255-265, 272-293, 297-344, 351-372, 376-423, 430-451, 455-502, 505-515,
##518-525, 527-528, 531-538, 540-541, 544-551, 553-561
##NOTE: Angles that are calculated using the gravitymean, are not included
##because the task was to extract all measurements on the mean and standard
##deviation for each measurement, not measures calculated using mean or std.

X_merged[c(7:40,47:80,87:120,127:160,167:200,
        203:213,216:226,229:239,242:252,
        255:265,272:293,297:344,351:372,
        376:423,430:451,455:502,505:515,
        518:525,527:528,531:538,540:541,
        544:551,553:561)]<-list(NULL)

##Then, adding the numbers of activities and subjects, because the subjects and activity labels are
##needed for the analysis at a later point to calculate subject means
##for different variables.

X_merged<-cbind(rbind(y_train,y_test),X_merged)##Adding the activity numbers
##now the first include column first the y_train and then y_test. Let's make it a factor variable.
X_merged[,1]<-factor(X_merged[,1])
levels(X_merged[,1])<-as.factor(activity_labels[,2])  ##replace the levels with activity labels in 
							  		##activity_labels -data frame column two


 ##rename the column containing the activities using a more

						##describing name.
colnames(X_merged)[1]<-"Activity"

##for (i in 1:6){				
##	good<-X_merged2$Activity==as.factor(i)
##	X_merged$Activity[good]<-as.factor(activity_labels[i,2])
##}

##Then add column with the subject numbers:
X_merged<-cbind(rbind(subject_train,subject_test),X_merged) 
colnames(X_merged)[1]<-"Subject#"		##Rename the column with a better name.
X_merged[,1]<-factor(X_merged[,1])		##Change it into a factor for later use.

##Next construct an empty data frame for the averages
##for different activities for different test subjects.
##It is known that there are 6 different activities and
##30 different test subjects, so the number of observations
##for these is 30 times 6 which equals 180, therefore 180 rows are needed.
##Number of columns is the number of different measurements that include
##mean or standard deviation i.e. the number of columns in X_merged.
##(columns for the subject numbers and activity labels are needed as well)

##First is needed a vector with each of the subject numbers six times, 
##because there are six activies for each subject.

##A function needs to be constructed because sApply is used.
rep_times <- function(x,times){rep(x,times)}
subject_rep<-sapply(unique(X_merged$Subject),rep_times,times=6)	##sapply applies rep_times
##This returns a matrix and it can be transformed as vector		##for each unique subject number
##using sapply with rbind:
Subject<-sapply(subject_rep,rbind)

##Also a vector that contains the activity labels 30 times is needed.
##(for each subject, we want each activity once. these are found for example
##in the levels of Activity column of the previous data frame.

Activity<-rep(levels(X_merged$Activity),30)

##Now a new data frame is constructed from these (the numberical data is added
##step by step later.

X_average<-data.frame(Subject, Activity)

##Then build a data frame into which we calculate the averages of the different variables
##for different subjects for different activities:
averages<-data.frame(matrix(NA, nrow = 180, ncol = (ncol(X_merged)-2)))	##Subtract 2 because
												##Subject and Activity
												##columns aren't needed.

##The averages for different subjects for different activities is
##calculated using two nested for loops.
##The outer(first) for loops through the different subject numbers
for (i in 1:length(unique(X_merged$Subject))){			

	##The second one loops through the different activities		
	for (j in 1:length(unique(X_merged$Activity))){

		##Averages are put on separate rows. The indexing is made running from 1 to 180.
		##Column means are calculated for a subsetted matrix. The subsetting chooses
		##all combinations of subjects and activities so that each subject has each activity
		##once. Column means are calculated for columns which include the measurements in the
		##matrix that was first built in this code.
		averages[j+(i-1)*6,]<-colMeans(X_merged[X_merged$Subject==unique(X_average$Subject)[i] &
						X_merged$Activity==unique(X_average$Activity)[j],][,3:ncol(X_merged)],
						na.rm=TRUE)
	}
}
##Column names for the measurements are copied from the 
##first matrix.l
colnames(averages)<-colnames(X_merged)[3:80]
colnames(averages)<-paste("Average:",colnames(X_merged)[3:80])
##And at last, the matrix with the activities and subjects is bound to
##the matrix with the averages for the measurements.
##NOTE: this is possible because the for loops above calculate the
##activity and subject averages in the same order as they appear in X_averages.
X_average<-cbind(X_average,averages)

write.table(X_average,"X_average.txt",row.name=FALSE)