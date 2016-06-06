if(!file.exists("./data1")){dir.create("./data1")}
my_data <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(my_data,destfile="./data1/Dataset.zip")

# Unzip dataSet to /data1 directory
unzip(zipfile="./data1/Dataset.zip",exdir="./data1")



# Reading trainings tables:
x_train <- read.table("./data1/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data1/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data1/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data1/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data1/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data1/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data1/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data1/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

colNames <- colnames(setAllInOne)

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

tidy <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
tidy <- tidy[order(tidy$subjectId, tidy$activityId),]
write.table(tidy, "tidy.txt", row.name=FALSE)