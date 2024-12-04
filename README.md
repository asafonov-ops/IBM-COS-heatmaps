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

**Usage**

zdi2heatmap_unsorted.sh is a version of zdi2heatmap.sh utility that preserves the original drive order in "zdi -zh" output.

**Usage:**

mkdelta_heatmap.sh accepts two input "cvs" files. both "csv" files must be produced by zdi2heatmap.sh utility (see above).

the first csv file is an earlier "zdi -zh" and the second file is the later "zdi -zh" normalized output file. 

File names are expected to have 6 digits timestamp. As an example - "112524" - November 25th, 2024.

**Example**

./mkdelta_heatmap.sh TS999999999-112524-0910.csv  TS999999999-120224-0910.csv

Output file: delta-251124-021224.csv and delta-251124-021224.pdf

"cvs" file captures difference in drive utilization and "pdf" file a heatmap representation of the difference in drive utilization between the two dates.
