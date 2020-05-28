#!/bin/bash
EDITOR="${EDITOR:-code}"

DATE=$(date +"%Y-%m-%d")
TITLE=$1
MYTITLE=$(echo ${TITLE} | sed 's/ /-/g')
echo ${MYTITLE}
NEWFILE=./src/posts/${DATE}-${MYTITLE}.md

# Make Asset directory for post
mkdir -p ./src/posts/${DATE}-${MYTITLE}/
open ./src/posts/${DATE}-${MYTITLE}

# Write header section
echo "---" >> ${NEWFILE}
echo "title: ${TITLE}" >> ${NEWFILE}
echo "date: ${DATE}" >> ${NEWFILE}
echo "draft: true" >> ${NEWFILE}
echo "tags: ${DATE}" >> ${NEWFILE}
echo "---" >> ${NEWFILE}

${EDITOR} ${NEWFILE}

