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

Example: 

./zdi2heatmap.sh TS999999999-zdi-zh-021224-1133.txt

Output files: TS999999999-zdi-zh-021224-1133.csv and TS999999999-zdi-zh-021224-1133.pdf


