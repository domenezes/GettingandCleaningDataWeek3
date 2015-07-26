print(getwd())
setwd("C:/Users/Diego/learningR/coursera/Getting and Cleaning Data/week 3/Course Project")
print(getwd())


# temp <- tempfile()
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
# for (i in temp) unzip(i)
# unlink(temp)


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
# 
# 
# print(str(x_train))
# print(str(y_train))
# print(str(subject_train))

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subj <- rbind(subject_train, subject_test)

features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')

# print(str(subj)[1])
# print(str(subj)[1000000])
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c('rowID', 'exercise')

index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
X <- X[, index_features] 
names(X) <- gsub("\\(|\\)", "", (features[index_features, 2]))


#print(dim(activities[Y[, 1], 2]))
#Y[, 1] = activities[Y[, 1], 2]

names(Y) <- "Exercise"
names(subj) <- "Subject"


combined <- cbind(subj, Y, X)
# print(names(combined))
# print(dim(combined))
# print(names(activities))
# print(dim(activities))
# print(str(activities))

print(length(3:dim(combined)[2]))
print(length(3:ncol(combined)))

combined_with_average <- aggregate(combined[,3:ncol(combined)],list(combined$Subject, combined$Exercise), mean)

colnames(combined_with_average)[1] <- "Subject"
colnames(combined_with_average)[2] <- "Exercise"

#print(names(combined_with_average))
#print(dim(combined_with_average))
write.table(combined_with_average, "tidyDataFileAVGtxt.txt",row.name=FALSE)
#print(dim(tidyDataFileAVGtxt.txt))

