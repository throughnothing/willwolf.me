#!/bin/bash
EDITOR=code

DATE=$(date +"%Y-%m-%d")
TITLE=$1
MYTITLE=$(echo ${TITLE} | sed 's/ /-/g')
echo ${MYTITLE}
NEWFILE=./src/posts/${DATE}-${MYTITLE}.md

# Write header section
echo "--" >> ${NEWFILE}
echo "title: ${TITLE}" >> ${NEWFILE}
echo "date: ${DATE}" >> ${NEWFILE}
echo "--" >> ${NEWFILE}

${EDITOR} ${NEWFILE}

