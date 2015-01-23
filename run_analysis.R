library(plyr)

# STEP 1
# read training data, labels and subject
training_data <- read.table("train/X_train.txt")
training_label <- read.table("train/y_train.txt")
training_subject <- read.table("train/subject_train.txt")

# read test data, labels and subject
test_data <- read.table("test/X_test.txt")
test_label <- read.table("test/y_test.txt") 
test_subject <- read.table("test/subject_test.txt")

#join rows using rbind (rowbind) for training and test data, labels and subject
joined_data <- rbind(training_data, test_data)
joined_label <- rbind(training_label, test_label)
joined_subject <- rbind(training_subject, test_subject)

# STEP 2
features <- read.table("features.txt")
#features[,2] # data in this col is similar to: tBodyAcc-mean()-X or tBodyAcc-mean()-Y Or tBodyAcc-mean()-Z ...etc
#search an replace to give meaningful names to this column
features[,2] = gsub('-mean', 'Mean', features[,2]) #remove - and capitalize M
features[,2] = gsub('-std', 'Std', features[,2]) #remove - and capitalize S
features[,2] = gsub('[-()]', '', features[,2]) #remove -()
#now extract mean and std deviations for each measurements
mean_std_dev_cols <- grep(".*Mean.*|.*Std.*", features[,2])
joined_data <- joined_data[, mean_std_dev_cols]
joined_data

#STEP 3
activity_labels <- read.table("activity_labels.txt")

# update with activity names
joined_label[, 1] <- activity_labels[joined_label[, 1], 2]

#set column names
names(joined_label) <- "activity"

# Step4. 
names(joined_subject) <- "subject"
new_data <- cbind(joined_data, joined_label, joined_subject)

# STEP 5
# average of each variable for each activity and each subject
avg <- ddply(new_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(avg, "avgdata.txt", row.name=FALSE)


