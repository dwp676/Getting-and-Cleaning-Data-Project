#You should create one #R script called run_analysis.R that does the following.
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

#1) Merges the training and the test sets to create one data set.

#Set working Directory
setwd("..")
setwd("UCI HAR Dataset")

#Read train files to variables
activity_labels <- read.table("activity_labels.txt", header = FALSE)
features <- read.table("features.txt", header = FALSE)
subject_train <- read.table("train/subject_train.txt", header = FALSE)
X_train <- read.table("train/X_train.txt",header = FALSE)
Y_train <- read.table("train/Y_train.txt",header = FALSE)

#Clean up and lable train data
colnames(X_train) <- features[,2]
colnames(subject_train) <- "SubjectID"
colnames(Y_train) <- "ActivityID"
colnames(activity_labels) <- c("ActivityID","ActivityDescription")

#Combine training data
mergedtrainactivity <- merge(Y_train,activity_labels, by = "ActivityID")
trainingdata <- cbind(subject_train,mergedtrainactivity ,X_train)

#Next steps are to read files, name columns, and combine "test" folder data

#Read test files to variables
subject_test <- read.table("test/subject_test.txt", header = FALSE)
X_test <- read.table("test/X_test.txt", header = FALSE)
Y_test <- read.table("test/Y_test.txt", header = FALSE)

#Add column lables to test tables
colnames(subject_test) <- "SubjectID"
colnames(Y_test) <- "ActivityID"
colnames(X_test) <- features[,2]
  
#INSTRUCTION 3: Apply Descriptive Activity Names to both Test and Train tables.  Merge tables
mergedtestactivity <- merge(Y_test,activity_labels, by = "ActivityID")
testingdata <- cbind(subject_test,mergedtestactivity,X_test )

#INSTRUCTION 1:  Combine test and training tables into one table
combinedtables <- rbind(testingdata, trainingdata)

#INSTRUCTION 2: Subset columns to only include those with "mean" and "stdv" (use grepl with sapply if possible)
columns <- colnames(combinedtables)
subsetnames <- grepl("SubjectID",columns) |grepl("Activity",columns)| (grepl("mean", columns)&!grepl("meanFreq",columns))| grepl("std",columns)

#Apply logical vector "subsetnames" to "combinedtables" to get columns that have "mean" or "std" in their column names
subsettable <-combinedtables[,subsetnames]

#INSTRUCTION 4: Appropriately labels the data set with descriptive variable names.
names(subsettable) <-gsub("^t","Time", names(subsettable))
names(subsettable) <-gsub("^f","Frequency", names(subsettable))
names(subsettable) <-gsub("Acc","Accelerometer", names(subsettable))
names(subsettable) <-gsub("Gyro","Gyroscope", names(subsettable))
names(subsettable) <-gsub("BodyBody","Body", names(subsettable))
names(subsettable) <-gsub("Mag","Magnitude", names(subsettable))

#INSTRUCTION 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
install.packages("dplyr")
library(dplyr)
FinalTidyOutput <-aggregate(. ~SubjectID + ActivityID + ActivityDescription, subsettable, mean)
FinalTidyOutput<-FinalTidyOutput[order(FinalTidyOutput$SubjectID, FinalTidyOutput$ActivityDescription),]

#Write resulting tidy table to output file in .txt format
write.table(FinalTidyOutput, file = "FinalTidyOutput.txt", row.name = FALSE)


