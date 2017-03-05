# Final Project
Final project for the "Getting and Cleaning Data" course from Coursera

## Required Package
This function requires reshape2. To install this package, run `install.packages('reshape2')`.

## Running the function
To run this function, set your working directory to the repository directory. Source run_analysis.R `source("run_analysis.R")` and run the function `run_analysis()`. This function will download and unzip the files required for the project and then perform the data manipulation.

To overwrite the tidy data file, `run_analysis(summary = TRUE)`.

## Explanation of Data Choices
There has been some discussion on whether or not to include the "meanFreq" variables in the summary. I chose to include these because it is much easier to remove data at a later date that is not needed than it is to add data back in, especially after further summarization.

I also chose to save the data in a long format in order for it to be considered a tidy set. Included in the function is an option to save the data in a wide format - you can run the following function to see this set: `run_analysis(summary = TRUE, long_form = FALSE)`.