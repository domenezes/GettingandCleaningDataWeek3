# GettingandCleaningDataWeek

Repository created to store files from Coursera course "Getting and Cleaning Data", Week 3.

In the GettingandCleaningDataWeek3 there is a R script named 'run_analysis.R'. When it is run the usual way it does:

1) Properly sets the working directory

2) Downloads the zip file with the data set

3) Loads both test and train data and merges them

4) Loads the features and activity labels

5) Extracts the mean and standard deviation column names and data

6) Creates a final data set

7) Creates a tidy data set with the average of each variable for each activity and each subject

9) Generates a .txt file that contains the average information from the previous step


The aforementioned R script can also be seen below.

print(getwd())
setwd("C:/Users/Diego/learningR/coursera/Getting and Cleaning Data/week 3/Course Project")
print(getwd())


temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
for (i in temp) unzip(i)
unlink(temp)

#PART 1 - MERGING TRAINING AND TEST DATA SETS:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# print(dim(x_train))
# print(dim(x_test))
# print(dim(y_train))
# print(dim(y_test))
#print(dim(subject_train))
#print(dim(subject_test))

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subj <- rbind(subject_train, subject_test)

#PART 2 - EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND SD: (my friend suggested do this for part 2)
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feature_id', 'feature_name')

index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feature_name) 
X <- X[, index_features] 
names(X) <- gsub("\\(|\\)", "", (features[index_features, 2]))


#PART 3 - NAMING ACTIVITIES IN THE ACTIVITIES DATA SET:
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c('exercise_id', 'exercise_name')

#print(dim(activities[Y[, 1], 2])) 
#- my friend suggested the line below to properly the kinds of activities/exercises
#to each column
Y[, 1] = activities[Y[, 1], 2]

#PART 4 - LABELLING DATA SET PROPERLY:
names(Y) <- "Exercise"
names(subj) <- "Subject"

#combining X, Y and subj by columns
combined <- cbind(subj, Y, X)

#PART 5 - CREATING A TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT:
print(length(3:ncol(combined)))

combined_with_average <- aggregate(combined[,3:ncol(combined)],list(combined$Subject, combined$Exercise), mean)

colnames(combined_with_average)[1] <- "Subject"
colnames(combined_with_average)[2] <- "Exercise"

write.table(combined_with_average, "FinalTidyDataSet.txt",row.name=FALSE)


