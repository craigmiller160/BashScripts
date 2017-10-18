#!/bin/bash
# Unzip-All Script
# Requires 7zip

files=($(ls))

for f in ${files[@]}
do
    if [[ -f "$f" && "$f" == *.zip ]]; then
        echo "Unzipping file: $f"
        file=$(basename $f)
        filename="${file%.*}"
        7z x "$f" "-o$filename"
    fi
done
