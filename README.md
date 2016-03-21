# Getting-and-Cleaning-Data-Project

This is the final course project for Getting and Cleaning Data.  The run_analysis.R script is used to aggregate and summarize performance data through the following process:

1. Reads study files into R
2. Aggregates multiple disparate files from Train and Test groups and names column headers
3. Combines Train and Test group data into one table
4. Subset columns to only include those with "mean" and "stdv" 
5. Appropriately label headers in the resulting data set with descriptive variable names
6. Create a second, independent tidy data set with the average of each variable for each activity and each subject
7. Write the final tidy table to a text file
