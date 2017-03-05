# This assumes that your working directory is the repo. 
# This file needs to be sourced in order for the analysis to run properly.
# source("run_analysis.R")
library(reshape2)
run_analysis <- function(summary = FALSE, long_form = TRUE) {
  
  if (!file.exists("UCI HAR Dataset")) {
    unzip_data_files()
  }
  data_file_path <- file.path(".","UCI HAR Dataset")
  
  ## Merge the training and the test sets & label the data
  all_data <- merge_sets(data_file_path)
  
  ## Extract measurements on the mean and standard deviation for each measurement.
  extracted_data <- all_data[ , grepl("subject|y_data|mean|std|Mean", colnames(all_data))]
  
  ## Name the activities in the data set
  extracted_data <- assign_activity_names(extracted_data, data_file_path)

  ## Create an independent tidy data set with the average of each variable for each 
  ## activity and each subject.
  tidy_data_summary <- aggregate(. ~ subject + activity_label, extracted_data, mean)
  if (long_form) {
    tidy_data_summary <- melt(tidy_data_summary, 
                              id = c("subject","activity_label"), 
                              measure.vars = setdiff(colnames(tidy_data_summary), c("subject", "activity_label")))
    colnames(tidy_data_summary) <- c("subject","activity_label","variable","mean")
  }
  
  # Write the tidy data if option is selected
  if (summary) {
    write.table(tidy_data_summary, file="tidy_data_summary.txt")
  }
}

unzip_data_files <- function() {
  # Checks for zip file. If it does not exist, downloads zip file. Unzips file.
  if (!file.exists("dataset.zip")) {
    print("Downloading file")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "dataset.zip")
  }
  print("Unzipping file")
  unzip("dataset.zip")
}

merge_sets <- function(data_file_path) {
  features <- read.table(file.path(data_file_path, "features.txt"))
  
  test_data <- merge_separate_sets(data_file_path, "test", features)
  train_data <- merge_separate_sets(data_file_path, "train", features)
  
  all_data <- rbind(test_data, train_data)
  
  return(all_data)
}

merge_separate_sets <- function(data_file_path, file_type, features) {
  file_path <- file.path(data_file_path, file_type)
  file_list <- list.files(file_path, pattern = ".txt", full.names = TRUE)
  
  parse_data <- function(pattern, file_list) {
    # Searches the list of files for the filename to be read in.
    # TODO: This will break if multiple files are found.
    data_file <- file_list[grep(pattern, file_list)]
    data_points <- read.table(data_file)
    return(data_points)
  }
  
  subject_data <- parse_data("subject_", file_list)
  x_data <- parse_data("X_", file_list)
  y_data <- parse_data("y_", file_list)
  
  return_data <- cbind(subject_data, 
                       y_data, 
                       x_data)
  
  # Set the name of the columns to the "features" list
  colnames(return_data) <- c("subject","activity_code",as.character(features[ , 2]))
  
  return(return_data)
}

assign_activity_names <- function(extracted_data, data_file_path) {
  activity_labels <- read.table(file.path(data_file_path,"activity_labels.txt"))
  colnames(activity_labels) <- c("activity_code","activity_label")
  extracted_data <- merge(extracted_data, activity_labels)
  extracted_data$activity_code <- NULL
  return(extracted_data)
}