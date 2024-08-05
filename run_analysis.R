library(dplyr)

# Download and unzip materials
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "PGD",method = "curl")
unzip("PGD",exdir = "PGDUZ")

# Read a features file
url_features <- "PGDUZ\\UCI HAR Dataset\\features.txt"
features <- read.table(url_features, col.names = c("index", "feature_name"))



#  Read training data files

# Read the training data file and 
# extract only the measurements based on the mean and standard deviation for each measurement and 
# label the data set appropriately with descriptive variable names
url_train_data <- "PGDUZ\\UCI HAR Dataset\\train\\x_train.txt"
train_data <- read.table(url_train_data,col.names = features$feature_name)
train_data <- train_data %>% select(contains("std"),contains("mean..."))

# Read a labels training data file
url_labels_train_data <- "PGDUZ\\UCI HAR Dataset\\train\\y_train.txt"
labels_train_data <- read.table(url_labels_train_data, col.names = "labels")

# Read a subject training data file
url_subject_train_data <- "PGDUZ\\UCI HAR Dataset\\train\\subject_train.txt"
subject_train_data <- read.table(url_subject_train_data,col.names = "subject")



#  Read testing data files

# Read the testing data file and 
# extract only the measurements based on the mean and standard deviation for each measurement and 
# label the data set appropriately with descriptive variable names
url_test_data <- "PGDUZ\\UCI HAR Dataset\\test\\x_test.txt"
test_data <- read.table(url_test_data,col.names = features$feature_name)
test_data <- test_data %>% select(contains("std"),contains("mean..."))

# Read a labels testing data file
url_labels_test_data <- "PGDUZ\\UCI HAR Dataset\\test\\y_test.txt"
labels_test_data <- read.table(url_labels_test_data, col.names = "labels")

# Read a subject testing data file
url_subject_test_data <- "PGDUZ\\UCI HAR Dataset\\test\\subject_test.txt"
subject_test_data <- read.table(url_subject_test_data,col.names = "subject")


# Read a activity labels data file
url_activity_labels <- "PGDUZ\\UCI HAR Dataset\\activity_labels.txt"
activity_labels_df <- read.table(url_activity_labels,col.names = c("index","activity_labels")) 



#  Merges the training and the test sets to create one data set.

# Merges the training sets
total_train_data <- bind_cols(subject_train_data,labels_train_data,train_data)

# Merges the test sets
total_test_data <- bind_cols(subject_test_data,labels_test_data,test_data)

# create one data set
total_data <- bind_rows(total_train_data,total_test_data)



# Use descriptive activity names to name activities in the data set
total_data <- total_data %>% 
        mutate(labels = activity_labels_df[labels,]$activity_labels) %>% 
        rename(activity_labels = labels) 






# Create a second, independent data set and averaged each variable for each activity and topic 
# from the data set
final_data <- total_data %>%
        group_by(subject, activity_labels) %>%
        summarize(across(everything(), mean, .names = "avg_{.col}"), .groups = "drop")



# Save the final data to a file
write.table(final_data, "final_data.txt", row.names = FALSE)