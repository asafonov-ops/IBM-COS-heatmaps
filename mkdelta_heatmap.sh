#!/usr/bin/bash

t1=$(mktemp)
t2=$(mktemp)
t3=$(mktemp)
t4=$(mktemp)
t5=$(mktemp)
t6=$(mktemp)
t7=$(mktemp)

cat $1 | awk -F ',' '{ print $1}' | grep -v ^Slicestor$ > $t1
cat $2 | awk -F ',' '{ print $1}' | grep -v ^Slicestor$ > $t2

# echo $t1
# echo $t2

cat $1 | sed -e 's/-//g' > $t3
cat $2 | sed -e 's/-//g' > $t4

OF=delta-$(echo $1 | perl -lne 'print $& if /-\d\d\d\d\d\d-/' | sed -e 's/-//g')-$(echo $2 | perl -lne 'print $& if /-\d\d\d\d\d\d-/' | sed -e 's/-//g').csv
echo Generating delta CVS file: $OF
POF=$(echo $OF | sed -e 's/csv/pdf/g')
python3 -c "import numpy as np
import sys

# print (sys.argv[1])
with open(sys.argv[1]) as f:
    ncols = len(f.readline().split(','))
# print(ncols);

fill_value = 0
converters = {i: lambda s: float(s.strip() or fill_value) for i in range(1,ncols-1)}

data = np.loadtxt(sys.argv[1], delimiter=',', skiprows=1, converters = converters , usecols=range(1,ncols-1))

data1 = np.loadtxt(sys.argv[2], delimiter=',', skiprows=1, converters = converters , usecols=range(1,ncols-1))

# print(data);
# print(data1);


result = np.array(data) - np.array(data1)

# print(result)

np.savetxt(sys.argv[3], result, delimiter=',',fmt='%2.2f')" $t4 $t3 $t5 

# echo $t5

paste -d "," $t1 $t5 > $t6
head -1 $1 > $OF
cat $t6 >> $OF

rm $t1 $t2 $t3 $t4 $t5 $t6
echo Generating delta heamap file: $POF

echo "library(ggplot2)
library(reshape2)
library(plyr)
library(scales)
library(stringr)
clr <-c('darkblue')
hm <- read.csv(commandArgs(TRUE)[1])
hm.m <-melt(hm)
# hm.m<-ddply(hm.m, .(variable), transform,rescale = rescale(value))
hm.m<-ddply(hm.m, .(variable), transform,rescale = rescale(value,to = c(-1,1), from =c(-100,100)))
p <- ggplot(hm.m, aes(variable, Slicestor)) + geom_tile(aes(fill = rescale),colour = 'white') +  scale_fill_gradient2(low = 'darkblue',high = 'orange' ,na.value = 'grey50')
p + ggtitle(str_extract(commandArgs(TRUE)[1], regex('delta-[SB]CC-[:digit:]{6}-[:digit:]{6}'))) + geom_tile(aes(fill = value)) + geom_text(aes(label = round(value, 1))) + theme(plot.title = element_text(size = 40, face = 'bold')) + theme(axis.text.x = element_text(size = rel(1.4),angle = 90)) + theme(axis.text.y = element_text(size = rel(1.32))) + theme(axis.title.x = element_blank())

pdf(NULL)
ggsave(file=commandArgs(TRUE)[2],width=40, height=20)" | Rscript - $OF $POF

