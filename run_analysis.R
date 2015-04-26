## Check and if necessary install the following packages
## 1. dplyr
## 2. data.table
##

if(require("dplyr")){
        print("dplyr is loaded correctly")
} else {
        print("trying to install dplyr")
        install.packages("dplyr")
        if(require(dplyr)){
                print("dplyr installed and loaded")
        } else {
                stop("could not install dplyr")
        }
}

if(require("data.table")){
        print("data.table is loaded correctly")
} else {
        print("trying to install data.table")
        install.packages("data.table")
        if(require(data.table)){
                print("data.table installed and loaded")
        } else {
                stop("could not install data.table")
        }
}

##
## URL to load project data
##
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##

##
## Project data directory
##
## "./UCI HAR Dataset"
##

##
## Load/read raw data
##
## 1. features and activity label
## 2. training data
## 3. test data
##

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

##
## 1. Merge the training and test sets to create one data set.
##
##      The problem statement is ambiguous. So, I decided to combine X_train with X_test,
##      y_train with y_test, and subject_train with subject_test across rows
##      using rbind() function and later combine across column unsing cbind()
##

X_train_test <- rbind(X_train, X_test)
y_train_test <- rbind(y_train, y_test)
subject_train_test <- rbind(subject_train, subject_test)

##
## Assign column names to X_train_test dataset, y_train_test, and subject_train_test
##

colnames(X_train_test) <- t(features[, 2])
colnames(y_train_test) <- "Activity"
colnames(subject_train_test) <- "Subject"

##
## Merge to create one data set
##

trainTestData <- cbind(y_train_test, subject_train_test, X_train_test)

##
## 2. Extract only the measurements on the mean and standard deviation for each measurement.
##

meanStdExtractedData <- trainTestData[, grepl("mean|std", names(trainTestData), ignore.case = TRUE)]

##
## 3. Use descriptive activity names to name the activities in the data set.
##
##      The problem statement is a little ambiguous to me.
##      Should we apply the descriptive activitity name to the merged data set or
##      to the extracted data set?
##
##      I will endeavor to apply it to both.
##

##
##      For the merged data set
##

trainTestData$Activity <- as.character(trainTestData$Activity)
for (i in 1:nrow(activityLabels)) {
        trainTestData$Activity[trainTestData$Activity == i] <- as.character(activityLabels[i, 2])
}

##
##      For the extracted data set. To be able to use descriptive avtivity name with
##      extracted mean/standard deviation set we need to combine with
##      activity and subject columns.
##

meanStdData <- cbind(y_train_test, subject_train_test, meanStdExtractedData)

meanStdData$Activity <- as.character(meanStdData$Activity)
for (i in 1:nrow(activityLabels)) {
        meanStdData$Activity[meanStdData$Activity == i] <- as.character(activityLabels[i, 2])
}

##
## 4. Appropriately label the data set with descriptive variable names.
##
##      Again, because there was no explicit mention of which data set to apply the
##      task to I will apply it to both merged and extracted data set.
##
## Rule for syntactically valid variable name in R is:
##      A syntactic name is a string the parser interprets as this type of expression.
##       It consists of letters, numbers, and the dot and
##      (for versions of R at least 1.9.0) underscore characters, and starts with either
##      a letter or a dot not followed by a number.
##      Reserved words are not syntactic names.
##
## Using document UCI HAR Dataset.names the following changes will be made:
##      "t" in name of variable will be changed to "timeDomain"
##      "f" -> "frequencyDomain"
##      "Acc" -> "Acceleration"
##      "Gyro" -> "Gyroscope"
##      "Mag" -> "Magnitude"
##      "BodyBody" -> "Body"
##      "()" and "," will be removed
##      "-" -> "."
##
##      Names of merged data is in names(trainTestData) and
##      names of extracted data in names(meanStdData)
##

##
##      Process names for merged data
##

##      Make substitutions
names(trainTestData) <- gsub("^t", "TimeDomain.", names(trainTestData))
names(trainTestData) <- gsub("^f", "frequencyDomain.", names(trainTestData))
names(trainTestData) <- gsub("tBody", "TimeDomainBody.", names(trainTestData))
names(trainTestData) <- gsub("Acc", "Acceleration", names(trainTestData))
names(trainTestData) <- gsub("Gyro", "Gyroscope", names(trainTestData))
names(trainTestData) <- gsub("Mag", "Magnitude", names(trainTestData))
names(trainTestData) <- gsub("BodyBody", "Body", names(trainTestData))
names(trainTestData) <- gsub("angle", "Angle", names(trainTestData))
names(trainTestData) <- gsub("gravity", "Gravity", names(trainTestData))
names(trainTestData) <- gsub("-mean()", ".Mean", names(trainTestData), ignore.case = TRUE)
names(trainTestData) <- gsub("-std()", ".StandardDeviation", names(trainTestData), ignore.case = TRUE)
names(trainTestData) <- gsub("-freq()", ".Frequency", names(trainTestData), ignore.case = TRUE)
names(trainTestData) <- gsub("min", "Minimum", names(trainTestData))
names(trainTestData) <- gsub("max", "Maximum", names(trainTestData))
names(trainTestData) <- gsub("iqr", "IQR", names(trainTestData))
names(trainTestData) <- gsub("entropy", "Entropy", names(trainTestData))
names(trainTestData) <- gsub("energy", "Energy", names(trainTestData))
names(trainTestData) <- gsub("mad", "MedianAbsoluteDeviation", names(trainTestData))
names(trainTestData) <- gsub("skewness", "Skewness", names(trainTestData))
names(trainTestData) <- gsub("kurtosis", "Kurtosis", names(trainTestData))
names(trainTestData) <- gsub("MeanFreq", "MeanFrequency", names(trainTestData))
names(trainTestData) <- gsub("sma", "SimpleMovingAverage", names(trainTestData))
names(trainTestData) <- gsub("arCoeff", "AutoRegCoefficient", names(trainTestData))
names(trainTestData) <- gsub("correlation", "Correlation", names(trainTestData))

##      Remove open and closed parentheses
names(trainTestData) <- gsub("\\(\\)", "", names(trainTestData), perl = TRUE)

##      Remove hyphen
names(trainTestData) <- gsub("\\-", ".", names(trainTestData), perl = TRUE)

##      Remove open parenthesis
names(trainTestData) <- gsub("\\(", ".", names(trainTestData), perl = TRUE)

##      Remove comma
names(trainTestData) <- gsub("\\,", ".", names(trainTestData), perl = TRUE)

##      Remove closing parenthesis
names(trainTestData) <- gsub("\\)", "", names(trainTestData), perl = TRUE)

##      Snytactically valid names
names(trainTestData) <- make.names(names(trainTestData))

##
##      Process names for extracted data
##

##      Make substitutions
names(meanStdData) <- gsub("^t", "TimeDomain.", names(meanStdData))
names(meanStdData) <- gsub("^f", "frequencyDomain.", names(meanStdData))
names(meanStdData) <- gsub("tBody", "TimeDomainBody.", names(meanStdData))
names(meanStdData) <- gsub("Acc", "Acceleration", names(meanStdData))
names(meanStdData) <- gsub("Gyro", "Gyroscope", names(meanStdData))
names(meanStdData) <- gsub("Mag", "Magnitude", names(meanStdData))
names(meanStdData) <- gsub("BodyBody", "Body", names(meanStdData))
names(meanStdData) <- gsub("angle", "Angle", names(meanStdData))
names(meanStdData) <- gsub("gravity", "Gravity", names(meanStdData))
names(meanStdData) <- gsub("-mean()", ".Mean", names(meanStdData), ignore.case = TRUE)
names(meanStdData) <- gsub("-std()", ".StandardDeviation", names(meanStdData), ignore.case = TRUE)
names(meanStdData) <- gsub("-freq()", ".Frequency", names(meanStdData), ignore.case = TRUE)
names(meanStdData) <- gsub("min", "Minimum", names(meanStdData))
names(meanStdData) <- gsub("max", "Maximum", names(meanStdData))
names(meanStdData) <- gsub("iqr", "IQR", names(meanStdData))
names(meanStdData) <- gsub("entropy", "Entropy", names(meanStdData))
names(meanStdData) <- gsub("energy", "Energy", names(meanStdData))
names(meanStdData) <- gsub("mad", "MedianAbsoluteDeviation", names(meanStdData))
names(meanStdData) <- gsub("skewness", "Skewness", names(meanStdData))
names(meanStdData) <- gsub("kurtosis", "Kurtosis", names(meanStdData))
names(meanStdData) <- gsub("MeanFreq", "MeanFrequency", names(meanStdData))
names(meanStdData) <- gsub("sma", "SimpleMovingAverage", names(meanStdData))
names(meanStdData) <- gsub("arCoeff", "AutoRegCoefficient", names(meanStdData))
names(meanStdData) <- gsub("correlation", "Correlation", names(meanStdData))

##      Remove open, and/or closed parentheses, hyphen and comma
names(meanStdData) <- gsub("\\(\\)", "", names(meanStdData))
names(meanStdData) <- gsub("\\-", ".", names(meanStdData))
names(meanStdData) <- gsub("\\(", ".", names(meanStdData))
names(meanStdData) <- gsub("\\,", ".", names(meanStdData))
names(meanStdData) <- gsub("\\)", "", names(meanStdData))

##      Snytactically valid names
names(meanStdData) <- make.names(names(meanStdData))

##
## 5. Create a second independent tidy data set with the average of each variable
##    for each activity and each subject from the data set in step 4.
##
##      For this problem I will use only the extracted data set.
##
##      In this project subject is coded as numeric, but it represents an actual
##      person that participated in the experiment.
##      Thus, it is preferable that we coerced it as factor.

meanStdData$Subject <- as.factor(meanStdData$Subject)
meanStdData <- data.table(meanStdData)

##
##      create tidy data set and write into a data file.
##

tidyDataSet <- aggregate(. ~ Subject + Activity, meanStdData, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$Subject, tidyDataSet$Activity), ]
write.table(tidyDataSet, file = "tidyData.txt", row.names = FALSE)