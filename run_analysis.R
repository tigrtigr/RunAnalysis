##Library necessary tools

library(reshape2)

##Load features and index relevant variables

features <- read.table("./UCI HAR Dataset/features.txt")
var <- grep("mean[^Freq]|std[^Freq]", features$V2)

##Load activity labels

actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

##Load test data, assign variable names and subset variables for analysis

test <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test) <- features[,2]

test <- test[,var]

##Load test activity and test subject data

testAct <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(testAct) <- "activity"

testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(testSub) <- "subject"

##Merge subject id, activity id and test data

test <- cbind(testSub, testAct, test)

##Load train data, assign variable names and subset variables for analysis

train <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train) <- features[,2]

train <- train[,var]

##Load train activity and train subject data

trainAct <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(trainAct) <- "activity"

trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(trainSub) <- "subject"

##Merge subject id, activity id and train data

train <- cbind(trainSub, trainAct, train)

##Merge test and train data. Substitute activity id with descriptive labels

fullData <- rbind(test, train)
fullData$activity <- actLabels[fullData$activity,2]

##Melt data and build a tidy table containing variable means

longData <- melt(fullData, id=c("subject", "activity"), measure.vars=names(fullData)[-(1:2)])
means <- dcast(longData, subject + activity ~ variable, mean)

##Write table

write.table(means, file="./UCI HAR Dataset/means.txt", row.names = FALSE)