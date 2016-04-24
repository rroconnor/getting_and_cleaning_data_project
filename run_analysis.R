library(reshape2)

#1. Merge TRaining and Test Datasets:
# Read files:
features <- read.table('./UCI HAR Dataset/features.txt', header=F)
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', header=F)
subjectTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt', header=F)
xTrain <- read.table('./UCI HAR Dataset/train/x_train.txt', header=F)
yTrain <- read.table('./UCI HAR Dataset/train/y_train.txt', header=F)
subjectTest <- read.table('./UCI HAR Dataset/test/subject_test.txt', header=F)
xTest <- read.table('./UCI HAR Dataset/test/x_test.txt', header=F)
yTest <- read.table('./UCI HAR Dataset/test/y_test.txt', header=F)

#Assign dataset column names:
colnames(activityLabels) <- c('activityId','activity')
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[ , 2] 
colnames(yTrain) <- "activityId"
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[ , 2]
colnames(yTest) <- "activityId"

#combine datasets:
fullData <- rbind(cbind(subjectTrain, yTrain, xTrain), cbind(subjectTest, yTest, xTest))

#2. Extract Measurements on Mean and Standard Deviation:
colNames <- colnames(fullData)
logic <- grep(".*activity*|.*subject*|.*mean\\(.*|.*std.*", colNames)
finalMeasures <- fullData[, logic]

#3. Name the Activities in the Dataset:
#4. Label Datset with Descriptive Variable Names:
colNames<- colNames[logic]
colNames= gsub('-mean', 'Mean', colNames)
colNames = gsub('-std', 'Std', colNames)
colNames <- gsub('[-()]', '', colNames)
colnames(finalMeasures) <- colNames

final <-merge(finalMeasures, activityLabels, by='activityId', all.x=T)
final$activityId <- NULL

#5. creates a second, independent tidy data set with the average of each variable for each activity and each subject:
final$subjectId <- as.factor(final$subjectId)

final.melted <- melt(final, id = c("subjectId", "activity"))
final.mean <- dcast(final.melted, subjectId + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)