#!/usr/bin/bash

if [[ $1 ]] 
then	
	echo $1 | grep -q ".*\.txt$"
	if [[ $? -ne 0 ]]
	then 
		echo Usage: $0 {zdi-zh_output}.txt
		exit
	fi

else
	echo Usage: $0 {zdi-zh_output}.txt
	exit
fi

OF=$( echo $1 | sed -e 's/txt/csv/g')
POF=$( echo $1 | sed -e 's/txt/pdf/g')
echo Output file: $OF

du=$(cat $1 | python3 -c "
import re
import sys
import fileinput

p=re.compile(r'^icos(([a-z0-9][a-z0-9\-]*[a-z0-9])|[a-z0-9]+\.)*([a-z]+|xn\-\-[a-z0-9]+)\.?')
u=re.compile('^[a-f0-9]{8}-?[a-f0-9]{4}-?4[a-f0-9]{3}-?[89ab][a-f0-9]{3}-?[a-f0-9]{12}', re.I)

for line in fileinput.input():
        if p.match (line.strip()):
            m=p.match (line.strip())
        if u.match (line.strip()):
            print(m.group(),line.strip())" |  awk '{ print $3 }' | sort -u )


hu=$(cat $1 | python3 -c "
import re
import sys
import fileinput

p=re.compile(r'^icos(([a-z0-9][a-z0-9\-]*[a-z0-9])|[a-z0-9]+\.)*([a-z]+|xn\-\-[a-z0-9]+)\.?')
u=re.compile('^[a-f0-9]{8}-?[a-f0-9]{4}-?4[a-f0-9]{3}-?[89ab][a-f0-9]{3}-?[a-f0-9]{12}', re.I)

for line in fileinput.input():
        if p.match (line.strip()):
            m=p.match (line.strip())
        if u.match (line.strip()):
            print(m.group(),line.strip())" |  awk '{ print $1 }' | sort -u )



all=$(cat $1 | python3 -c "
import re
import sys
import fileinput

p=re.compile(r'^icos(([a-z0-9][a-z0-9\-]*[a-z0-9])|[a-z0-9]+\.)*([a-z]+|xn\-\-[a-z0-9]+)\.?')
u=re.compile('^[a-f0-9]{8}-?[a-f0-9]{4}-?4[a-f0-9]{3}-?[89ab][a-f0-9]{3}-?[a-f0-9]{12}', re.I)

for line in fileinput.input():
        if p.match (line.strip()):
            m=p.match (line.strip())
        if u.match (line.strip()):
            print(m.group(),line.strip())" |   awk '{ print $1","$3","$14}' | sed -e 's/%//')


function float_gt() {     perl -e "{if($1>$2){print -$1} else {print $1}}"; } ;


printf "%s" Slicestor > $OF 
for k in  $(echo $du) ; do printf "%s" ,$k ; done >> $OF ; echo >> $OF  
for j in $(echo $hu) ; do echo processing $j >&2 ;   printf "%s" $j ; for i in $(echo $du) ; do c=$( for l in $(echo $all) ; do echo $l ; done | grep ^$j | grep -w $i | awk -F ',' '{ print $3}') ; if [ "x$c" != "x" ]; then  c=$(float_gt $c 99) ; fi ; printf "%s" ,$c  ; done ; echo ; done >> $OF


echo "library(ggplot2)
library(reshape2)
library(plyr)
library(scales)
clr <-c('darkblue')
hm <- read.csv(commandArgs(TRUE)[1])
hm.m <-melt(hm)
hm.m<-ddply(hm.m, .(variable), transform,rescale = rescale(value,to = c(-1,1), from =c(-100,100)))
p <- ggplot(hm.m, aes(variable, Slicestor)) + geom_tile(aes(fill = rescale),colour = 'white') +  scale_fill_gradient2(low = 'darkred',high = 'navyblue' ,na.value = 'grey50')
p + theme(axis.text.x = element_text(size = rel(1.4),angle = 90)) + theme(axis.text.y = element_text(size = rel(1.32))) + theme(axis.title.x = element_blank())
pdf(NULL)
ggsave(file=commandArgs(TRUE)[2],width=40, height=20)" | Rscript - $OF $POF
echo Output Heatmap: $POF
