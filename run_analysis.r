#Activate plyr library
library(plyr)
library(dplyr)
library(reshape2)

#Read all raw data
trainset <- read.delim("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
trainlabel <- read.delim("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")
trainsubject <- read.delim("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
testset <- read.delim("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
testlabel <- read.delim("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")
testsubject <- read.delim("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
activity_labels<-read.delim("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
features<-read.delim("UCI HAR Dataset/features.txt", header=FALSE, sep="")

#Label columns in datasets with features
colnames(trainset)<-features[,2]
colnames(testset)<-features[,2]

#Keep only columns that contain mean or standard deviation
trainset[,grepl("mean|std", names(trainset))]
testset[,grepl("mean|std", names(testset))]

#match labels with activity
trainlabel2 <-join(trainlabel,activity_labels, by = "V1")
testlabel2 <-join(testlabel,activity_labels, by = "V1")

#add activity and subject information into datasets
trainset$activity <- trainlabel2$V2
testset$activity <- testlabel2$V2
trainset$subject <- trainsubject$V1
testset$subject <- testsubject$V1

#Combine datasets into one data frame
combineddata<-rbind(testset,trainset)

#Create new data set containing average of each variable for each activity and each subject
datamelt<-melt(combineddata,id=c("subject","activity"))
export<-dcast(datamelt, subject + activity~ variable,mean)

#write table as file called export.txt
write.table(export, file="export.txt", row.names = FALSE)


