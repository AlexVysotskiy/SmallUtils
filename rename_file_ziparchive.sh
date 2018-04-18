#!/bin/bash

if [ $# -eq 3 ]
then

    file=$1
    old=$2
    new=$3

    if [ ! -f $file ] || [ ! -r $file ]; then
        echo "File not found!"
        exit 1
    fi

    output=''
    found=0

    zipnote $1 | {
        while IFS= read -r line
        do
          output+=$line
          output+=$'\n'
          if [[ $line =~ .*$old.* ]]; then
            found=1
            output+=$'@='$new
            output+=$'\n'
          fi
        done

        if [ $found = 1 ]; then

            tmpfile="./renamearchive."$RANDOM

            echo "$output" > "$tmpfile"
            zipnote -w $1 < "$tmpfile"
            rm -f "$tmpfile"

            echo "Changes was done!"
        else
            echo "Required file wasn't found!"
        fi
    }
else
    echo "No arguments supplied"
fi