# Step 1
# Merges the training and the test sets to create one data set.
#################################################################################

# load training data
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# load testing data
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# merge training and testing data
train <- cbind(X_train, y_train, subject_train)
test <- cbind(X_test, y_test, subject_test)
train_test <- rbind(train, test)


# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement. 
#################################################################################

features <- read.table("./features.txt")

# locate the positions of the 66 features
# 33 mean() and 33 std() features to extract
mean_and_std_positions <- grep("mean\\(|std\\(",features$V2)

# subset the required columns
# column 562 is y variable, the activity type label
# column 563 is subject number
train_test_selected <- train_test[,c(mean_and_std_positions,562,563)]

# Step 3
# Uses descriptive activity names to name the activities in the data set
#################################################################################

activity_labels <- read.table("./activity_labels.txt")

# train_test_selected$V1.1 and activity_labels$V1 are both the activity label
all_data <- merge(train_test_selected, activity_labels, by.x = "V1.1", by.y = "V1", all = TRUE)

# Step 4
# Appropriately labels the data set with descriptive variable names. 
#################################################################################

names(all_data) <- c("activity_label", as.character(features$V2[mean_and_std_positions]), "subject_number", "activity_name")
names(all_data) 

# Step 5
# Creates a tidy data set with the average of each variable for each activity and each subject.
#################################################################################

# remove not needed variable: activity_label
all_data$activity_label<-NULL

# aggregate to get tidy data
tidy_data <- aggregate( .~ subject_number+activity_name, data=all_data, mean)
write.table(tidy_data, "../tidy_data.txt", row.name=FALSE)