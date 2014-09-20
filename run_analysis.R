library(dplyr)

###Merges the training and the test sets to create one data set.
fd <- file("UCI HAR Dataset/test/subject_test.txt","r")
subject_test <- read.table(fd)
close(fd)
fd <- file("UCI HAR Dataset/train/subject_train.txt","r")
subject_train <- read.table(fd)
close(fd)
subject_all <- rbind(subject_train, subject_test)

fd <- file("UCI HAR Dataset/test/X_test.txt","r")
X_test <- read.table(fd)
close(fd)
fd <- file("UCI HAR Dataset/train/X_train.txt","r")
X_train <- read.table(fd)  
close(fd)
X_all <- rbind(X_train, X_test)

fd <- file("UCI HAR Dataset/test/y_test.txt","r")
y_test <- read.table(fd)
close(fd)
fd <- file("UCI HAR Dataset/train/y_train.txt","r")
y_train <- read.table(fd)    
close(fd)
y_all <- rbind(y_train, y_test)


###Extracts only the measurements on the mean and standard deviation for each measurement. 
fd <- file("UCI HAR Dataset/features.txt","r")
col_labels <- readLines(fd)
close(fd)
colnames(X_all) <- col_labels 
X_all <- X_all[grep("mean|std",col_labels)]  #filter variables with string "mean" or "std" on its name

###Uses descriptive activity names to name the activities in the data set
y_all[y_all==1] <- "walking"
y_all[y_all==2] <- "walking up"
y_all[y_all==3] <- "walking down"
y_all[y_all==4] <- "sitting"
y_all[y_all==5] <- "standing"
y_all[y_all==6] <- "laying"


###Appropriately labels the data set with descriptive variable names. 
names(X_all) <- sub("[0-9]+ ", "",names(X_all)) ##removing the number at the beginning

##features_info doesn't talk about any BodyBody combination, so I'm considering it an error and fixing it
names(X_all) <- sub("BodyBody", "Body",names(X_all)) 

vbles <- names(X_all)#print(length(vbles))
for(i in 1:length(vbles) ){
    vbles[i] <- sub("^t","time ",vbles[i])
    vbles[i] <- sub("^f","frequency ",vbles[i])
    
    vbles[i] <- sub("-meanFreq\\(\\)"," mean",vbles[i])
    vbles[i] <- sub("-mean\\(\\)$"," mean",vbles[i])
    vbles[i] <- sub("-mean\\(\\)"," mean",vbles[i])
    vbles[i] <- sub("-std\\(\\)"," standard deviation",vbles[i])
    
    vbles[i] <- sub("-X$"," on the X axis",vbles[i])
    vbles[i] <- sub("-Y$"," on the Y axis",vbles[i])
    vbles[i] <- sub("-Z$"," on the Z axis",vbles[i])
    
    vbles[i] <- sub("BodyAcc ","body acceleration ",vbles[i])
    vbles[i] <- sub("GravityAcc ","gravity acceleration ",vbles[i])
    vbles[i] <- sub("BodyAccJerk ","body linear acceleration Jerk signal ",vbles[i])
    vbles[i] <- sub("BodyGyro ","body angular velocity ",vbles[i])
    vbles[i] <- sub("BodyGyroJerk ","body angular velocity Jerk signal ",vbles[i])
    vbles[i] <- sub("BodyAccMag ","body acceleration magnitude ",vbles[i])
    vbles[i] <- sub("GravityAccMag ","gravity acceleration magnitude ",vbles[i])
    vbles[i] <- sub("BodyAccJerkMag ","body acceleration Jerk signal magnitude ",vbles[i])
    vbles[i] <- sub("BodyGyroMag ","body angular velocity magnitude ",vbles[i])
    vbles[i] <- sub("BodyGyroJerkMag ","body angular velocity Jerk signal magnitude ",vbles[i])
}

for(i in 1:length(vbles)){
    vbles[i] <- gsub(" ","_",vbles[i])   #change spaces for underscores
}
names(X_all) <- vbles

###From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

X_all<- cbind(subject = subject_all[,1], X_all) ##adding subject and activity columns 
X_all <- cbind(activity = y_all[,1], X_all )

X_all <- melt(X_all, id = c("subject", "activity"))  #subject and activity values will act as 'primary keys'
X_all <- dcast(X_all, subject + activity ~ variable, mean) #calculate mean of rest of variables values
#depending on the combination of values of subject and activity

write.table(X_all, file = "cp_result.txt", col.name=TRUE, row.name=FALSE)
    