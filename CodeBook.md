Code Book

Raw data

The raw data used in this project were obtained from URL below:

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	
The data represent data collected from the accelerometers from the Samsung Galaxy S smart phone. A full description is available at the site where the data was obtained:

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data was obtained from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smart phone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the experimenters captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset were randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

Data Transformation/Clean-up

A R script was developed called run_analysis.R to perform the following processes.

1. The training and test data sets were merged together to create a single data set
	Training data was contained X_train.txt.
	Test data was contained in X_test.txt.
	Activity IDs for training data were in y_train.txt.
	Activity IDs for test data were in y_test.txt.
	Subject IDs for training data were in subject_train.txt.
	Subject IDs for test data were in subject_test.txt.
	Features of data captured by the smart phone used in the experiments were stored in features.txt.
	These features were used as column names for both training and test data.

2. Extraction of mean and standard deviation measurements
	The merged data obtained in step 1. above was used as input to extract data whose variable name contains mean and std (standard deviation).
	
3. Descriptive activity names
	To provide clarity to the data, activity identifier (id) column was used to lookup description in the activity_labels.txt file.
	
4. Labelling Data with descriptive variable names
	Variables names contained in features.txt file and used in the merged and extracted data sets were appropriately adjusted to be readable. For example:
	"t" was changed to "TimeDomain",
	"f" to "FrequencyDomain",
	"Acc" to "Acceleration", etc.
	
5. Creating tidy data
	Finally, a tidy data was created containing the average of each variable for each activity and each subject.