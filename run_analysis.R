# include libraries required for this exercise.
library(reshape2)
library(plyr)

#setwd("./UCI HAR Dataset")

# Have the features data frame loaded.
features <- read.table("features.txt")
# Have the activities data frame loaded.
activities <- read.table("./activity_labels.txt")
# get the activity description as character rather than factors
activities[,2] <- as.character(activities[,2])
#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

#subsetting to have only the Std and Mean columns of the observations
training <- read.table("./train/X_train.txt")
# make a data frame of the activities, name the column appropriately
trainingactivities <- read.table("./train/Y_train.txt")
names(trainingactivities) <- "activity"
# meaningful names to the training activities
trainingactivities[, 1] <- activities[trainingactivities[, 1], 2]
# make a data frame of the subjects (people)
trainingsubjects <- read.table("./train/subject_train.txt")
names(trainingsubjects) <- "subject"
names(training) <- features[mean_and_std_features, 2]
# column bind the subjects, their activities and the subsetted training data
training <- cbind(trainingsubjects, trainingactivities, training)
# now you have a data frame for training ready.

# let's do the same as above for the test data
# subsetting to have only the Std and Mean columns
testing <- read.table("./test/X_test.txt")
# make a data frame of the subjects (people)
testingsubjects <- read.table("./test/subject_test.txt")
names(testingsubjects) <- "subject"
# make a data frame of the activities , name the columns appropriately
testingactivities <- read.table("./test/y_test.txt")
names(testingactivities) <- "activity"
testingactivities[, 1] <- activities[testingactivities[, 1], 2]
names(testing) <- features[mean_and_std_features, 2]
testing <- cbind(testingsubjects, testingactivities, testing)

#Merges the training and the test sets to create one data set.
# Now combine both testing and training
combineddata <- rbind(training, testing)

# select the subset that is relevant, drop others
combineddata <- combineddata[,1:68]

# Get the means for all the relevant columns
combineddata <- ddply(combineddata, .(subject, activity), function(x) colMeans(x[,3:68]))

#Uses descriptive activity names to name the activities in the data set
names(combineddata) <- gsub("[()]", "", names(combineddata))
names(combineddata) <- gsub("mean", "Mean", names(combineddata))
names(combineddata) <- gsub("std", "Std", names(combineddata))
names(combineddata) <- gsub("-", "", names(combineddata))

write.table(combineddata, "tidy.txt", row.name=FALSE)
