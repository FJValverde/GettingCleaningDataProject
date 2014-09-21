This page summarizes the results of my solution to the project statement:

* the script run_analysis.R can be sourced into R or run directly from RStudio to load the data, process it and produce the tidy.txt file described below. IMPORTANT: download it in the same directory where the data for the assigment live, open it with RStudio and set the RStudio wd variable with:

<tt>
Session -> Set Working Directory -> To Source File Location
</tt>

* CodeBook.md describes the design decisions to document the transformations in the data.

* tidy.txt is the raw textual dump of the tidied data as per the project requirements. I have successfully re-loaded it into R from the project directory with:

<tt>
newTidy <- read.table("./tidy.txt")
</tt>
