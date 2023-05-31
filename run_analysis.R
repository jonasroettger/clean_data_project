library(dplyr)

# Define the file URL and download it
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./dataset.zip")

# Unzip the dataset
unzip("dataset.zip")

# Load datasets
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merge the training and the test sets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
MergedData <- cbind(Subject, Y, X)

# Extract only the measurements on the mean and standard deviation
TidyData <- MergedData %>% select(subject, code, contains("mean"), contains("std"))

# Use descriptive activity names to name the activities in the data set
TidyData$code <- activity_labels[TidyData$code, 2]

# Appropriately label the data set with descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("^t", "time", names(TidyData))
names(TidyData)<-gsub("^f", "frequency", names(TidyData))
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))

# From the data set, creates a second independent tidy data set with the average of each variable for each activity and each subject
TidyData2 <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

# Write the data to a text file
write.table(TidyData2, "TidyData.txt", row.name=FALSE)
