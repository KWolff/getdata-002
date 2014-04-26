## Import data from local machine

fileLocation <- paste(getwd(),"/UCI HAR Dataset/",sep="")

testData <- read.table(paste(fileLocation,"/test/X_test.txt",sep=""))
subjectTest <- read.table(paste(fileLocation,"/test/subject_test.txt",sep=""))
activityTest <- read.table(paste(fileLocation,"/test/y_test.txt",sep=""))
trainData <- read.table(paste(fileLocation,"/train/X_train.txt",sep=""))
subjectTrain <- read.table(paste(fileLocation,"/train/subject_train.txt",sep=""))
activityTrain <- read.table(paste(fileLocation,"/train/y_train.txt",sep=""))
features <- read.table(paste(fileLocation,"/features.txt",sep=""))
activityLabels <- read.table(paste(fileLocation,"/activity_labels.txt",sep=""))


## Combine test and training data
combinedData <- rbind(testData,trainData)
activityData <- rbind(activityTest,activityTrain)
subjectData <- rbind(subjectTest,subjectTrain)

## Merge activity data to activity labels
activityDataLabeled <-merge(activityData,activityLabels,by="V1")
activityDataLabeled <- activityDataLabeled[,2]

## Extract feature names and assign them to the column names of combined data
featureNames <- as.character(features$V2)
names(combinedData) <- featureNames

## Identify features for mean and standard deviation
## and subset based on those features
meanStdFeatures <- grep("mean()|std()", featureNames)
filteredData <- combinedData[,meanStdFeatures]

## Add the subject and activity data back in
finalData <- cbind(subjectData,activityDataLabeled,filteredData)
names(finalData)[1] <- "Subject"
names(finalData)[2] <- "Activity"

meltedData <- melt(finalData, id=c("Subject","Activity"))
summarizedData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.csv(summarizedData, "SummarizedData.csv")

summarizedData

