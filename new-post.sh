#!/bin/bash
BLOG_EDITOR="${BLOG_EDITOR:-code}"
WEBSITE=https://willwolf.me

DATE=$(date +"%Y-%m-%d")
TITLE=$1
MYTITLE=$(echo ${TITLE} | sed 's/ /-/g' | tr [:upper:] [:lower:])
DATEURL=$(echo ${DATE} | sed 's/-/\//g')
MYURL="$WEBSITE/$DATEURL/$MYTITLE/"
echo ${MYTITLE}
echo ${MYURL}
NEWFILE=./src/posts/${DATE}-${MYTITLE}.md

# Make Asset directory for post
mkdir -p ./src/posts/${DATE}-${MYTITLE}/
open ./src/posts/${DATE}-${MYTITLE}

# Write header section
echo "---" >> ${NEWFILE}
echo "title: ${TITLE}" >> ${NEWFILE}
echo "date: ${DATE}" >> ${NEWFILE}
echo "draft: true" >> ${NEWFILE}
echo "# image: $MYURL" >> ${NEWFILE}
echo "# description: " >> ${NEWFILE}
echo "tags:" >> ${NEWFILE}
echo "---" >> ${NEWFILE}

${BLOG_EDITOR} ${NEWFILE}

