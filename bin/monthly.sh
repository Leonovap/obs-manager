#!/bin/bash

today=$(date +%Y-%m)
dest_dir="/data/data/com.termux/files/home/storage/downloads/Data_an/Archive"

echo "PROCESSING $(date +%B) DATA!"

cd Trackers

cat *.md > "results${today}.md"

mv "$output_file" "$dest_dir"

echo "Results were successfully compiled and moved to ${dest_dir}"