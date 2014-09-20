Original Dataset Description
============================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 
These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median 
filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal 
was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter 
with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals 
(tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm 
(tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, 
fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ                    #body acceleration 
* tGravityAcc-XYZ                 #gravity acceleration 
* tBodyAccJerk-XYZ                #body linear acceleration Jerk signal
* tBodyGyro-XYZ                   #body angular velocity 
* tBodyGyroJerk-XYZ               #body angular velocity Jerk signal
* tBodyAccMag                     #body acceleration magnitude
* tGravityAccMag                  #gravity acceleration magnitude
* tBodyAccJerkMag                 #body acceleration Jerk signal magnitude
* tBodyGyroMag                    #body angular velocity magnitude
* tBodyGyroJerkMag                #body angular velocity Jerk signal magnitude
* fBodyAcc-XYZ                    #body acceleration 
* fBodyAccJerk-XYZ                #body Jerk signal acceleration 
* fBodyGyro-XYZ                   #body angular velocity 
* fBodyAccMag                     #body acceleration magnitude
* fBodyAccJerkMag                 #body acceleration magnitude
* fBodyGyroMag                    #body angular velocity magnitude
* fBodyGyroJerkMag                #body angular velocity Jerk signal magnitude

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'


Transformations on the original data
====================================

1) First step is merging the training and the test set to create a unique dataset. In the datasets, the measurements values and the corresponding subject and activity values associated for each measurement are stored in three different files. So we can see that data is loaded into 

* subject_test, with 2947 rows and 1 column
* y_test, with 2947 rows and 1 column
* X_test with 2947 rows and 561 columns

and 

* subject_train, with 7352 rows and 1 column
* y_train, with 7352 rows and 1 column
* X_train with 7352 rows and 561 columns

Both sets are merged in

* subject_all, with 10299 rows and 1 column
* y_all, with 10299 rows and 1 column
* X_all with 10299 rows and 561 columns


2) Extracts only the measurements on the mean and standard deviation for each measurement.The features.txt file holds the names of the column variables in the measurements table. These names are assigned to the X_all data frame and after that a new version of X_all is created keeping only those columns whose variable names contain the strings "mean" or "std".

3) Uses descriptive activity names to name the activities in the data set. In the y_all data frame activities are representes as numbers. In the activity_labels.txt file provided in the dataset we can find the correspondence between these numbers and the activity they represent. The numbers are changed for the more friendly name of the activity. For instance, 1 = walking. 

4) Appropriately labels the data set with descriptive variable names. The names provided for the column variables are changed to more friendly names. 

* When the names begin with t or f that means they are referring to time or frequency, so the abbreviation is changed for the whole word. 
* Parenthesis are removed, all means becomen 'mean' and the std specified as standard deviation. 
* The X, Y and Z letters, that could be easily misunderstood as auxiliar names for variables, are clearly changed by 'on the X/Y/Z axis'.
* The measurement abbreviation names are changed by their full name. BodyAcc, body acceleration; GravityAcc, gravity acceleration; BodyAccJerk, body linear acceleration Jerk signal; BodyGyro, body angular velocity; BodyGyroJerk, body angular velocity Jerk signal; BodyAccMag, body acceleration magnitude; GravityAccMag, gravity acceleration magnitude; BodyAccJerkMag, body acceleration Jerk signal magnitude; BodyGyroMag, body angular velocity magnitude; BodyGyroJerkMag, body angular velocity Jerk signal magnitude. 
* In a last step blanks are changed by underscores.

5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. To do this first we need to bind the subject and activity columns to the measurements dataset. This will allow us to use the melt function on the whole data frame setting the subject and activity values as a kind of primary key. For each combination of subject-activity we will find several measurements for each one of the rest of variables. We want the mean of each one of these groups, and we calculate that with the dcast function once X_all has been melted. 

6) Finally, the resulting dataset is written in cp_result.txt. 
