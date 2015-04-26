
## Step 1 & 2: Merge the training and the test sets to create one data set. 
## Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./features.txt", sep="")   
choose <- sort(c(grep("mean", features[,2]), grep("std", features[,2])))    # for step 2
features_meanstd <- features[choose,]                                       # for step 2 
activitynames <- read.table("./activity_labels.txt", sep="", col.names=c("activity_number", "activity_name"))

Xtest <- read.table("./test/X_test.txt", sep="")[,choose]        # Step 2: extract only mean and std measurements
ytest <- read.table("./test/y_test.txt", sep="", col.names="activity_number")
subjtest <- read.table("./test/subject_test.txt", col.names="subject")

Xtrain <- read.table("./train/X_train.txt", sep="")[,choose]      # Step 2: extract only mean and std measurements
ytrain <- read.table("./train/y_train.txt", sep="", col.names="activity_number")
subjtrain <- read.table("./train/subject_train.txt", sep="", col.names="subject")

test <- cbind(subjtest, ytest, Xtest)         # One data set for test folder.
train <- cbind(subjtrain, ytrain, Xtrain)     # One data set for train folder.
dataset <- rbind(test,train)                          # This is the merged data set.  
rm(Xtest, ytest, subjtest, test, Xtrain, ytrain, subjtrain, train)     # Remove all other temporary data. 


## Step 3: Use descriptive activity names to name the activities in the data set. 
dataset <- merge(activitynames, dataset, by="activity_number", all=TRUE)


## Step 5: Create a tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
dataset2 <- dataset %>%
  group_by(activity_name, subject) %>%
  summarise_each(funs(mean))


## Step 4: Appropriately label the data set with descriptive variable names.
colnames(dataset2)[4:82] <- paste(features_meanstd[,2])
colnames(dataset2)[4:82] <- paste("mean of", names(dataset2[4:82]))

## Writing into a txt file.
write.table(dataset2, file="./upload/project_dataset.txt", row.names=FALSE)


