CodeBook.md
========

This code downloads data from the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/index.html) and creates a tidy dataset reporting means for each variabel within respective combinations of activities for subjects carrying a Samsung smartphne. 

## run_analysis.r
run_analysis.r agregates  individual functions to complete the defined task. Brefley, run_analysis.r accesses the specified original dataset, divides it into training and test sets, performs measurements, merges training and test data, and creates a data tablewith mean and standard deviations for each permutation of considitions. This provides 180 data points (30 activities x 60 measurement types). These outputs are saved as tidy.csv in the working directory
