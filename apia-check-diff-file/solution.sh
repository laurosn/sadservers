#!/bin/bash

DATA_DIR="/home/admin/data"

# Find the checksum that appears most (original content) vs the outlier (modified file)
most_common=$(md5sum "$DATA_DIR"/* | awk '{print $1}' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
modified_file=$(md5sum "$DATA_DIR"/* | grep -v "$most_common" | awk '{print $2}')
original_file=$(md5sum  "$DATA_DIR"/* | grep "$most_common" | head -1 | awk '{print $2}')

# Split both files into words, sort, then diff — the extra line is the added word
extra_word=$(diff \
    <(tr -s ' \n\t' '\n' < "$original_file" | sort) \
    <(tr -s ' \n\t' '\n' < "$modified_file"  | sort) \
  | grep '^>' | awk '{print $2}')

echo "$extra_word" > /home/admin/solution