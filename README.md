# IBM-COS-heatmaps
**To install R:**

sudo apt install r-base-core

**R packages installation:**

install.packages("ggplot2")

install.packages("reshape2")

install.packages("plyr")

install.packages("scales")

install.packages("stringr")

**Usage:**

zdi2heatmap.sh accepts a single parameter - text output of a "zdi -zh" IBM COS command. Input file must have a "txt" extension

It produces two output files - a "csv" faile - normalized form of the imput file and "pdf" - heatmap of individual drive utilization. 
