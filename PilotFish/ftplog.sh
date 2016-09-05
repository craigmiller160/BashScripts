#!/bin/bash
# Script to parse the FTP log text

FTPLOG=/Users/craigmiller/Documents/ftplog.txt
FTPLOG_SORT=/Users/craigmiller/Documents/ftplog-sorted.txt
FTPLOG_PARSED=/Users/craigmiller/Documents/ftplog-parsed.txt

if [ -f $FTPLOG ]; then
	echo "Deleting old ftplog.txt file"
	rm $FTPLOG
fi

if [ -f $FTPLOG_SORT ]; then
	echo "Deleting old ftplog-sorted.txt file"
	rm $FTPLOG_SORT
fi

if [ -f $FTPLOG_PARSED ]; then
	echo "Deleting old ftplog-parsed.txt file"
	rm $FTPLOG_PARSED
fi

files=($(ls -l | awk '{ print $9 }' | sort -nr))
for f in "${files[@]}"; do
	egrep 'FTPLISTENER*' $f | sort -n -k7 | tee -a $FTPLOG
done

# cat $FTPLOG | sort -n -k7 | tee -a $FTPLOG_SORT

# cat $FTPLOG_SORT

# count=0
# while read -r line || [[ -n "$line" ]]; do

# done

# IFS=$'\n'

# tid=0
# name=""
# target=""

# while read -r line || [[ -n "$line" ]]; do
# 	full_id=$(echo "$line" | awk '{ print $7 }')
# 	new_tid=$(echo "$full_id" | awk -F'-' '{ print $1 }')
# 	index=$(echo "$full_id" | awk -F'-' '{ print $2 }')
# 	new_name=$(echo "$line" | awk '{ print substr($0, index($0, $8)) }')

# 	if [ $new_tid != $tid ]; then
# 		tid=$new_tid
# 		printf " $name\n" | tee -a $FTPLOG_PARSED
# 		name="$new_name"
# 		printf "%3s: " "$tid" | tee -a $FTPLOG_PARSED
# 	fi

# 	case $index in
# 		1*) printf "arrive " | tee -a $FTPLOG_PARSED ;;
# 		2*) printf "start " | tee -a $FTPLOG_PARSED ;;
# 		3*) printf "write " | tee -a $FTPLOG_PARSED ;;
# 		4*) printf "done " | tee -a $FTPLOG_PARSED ;;
# 		5*) printf "closing " | tee -a $FTPLOG_PARSED ;;
# 	esac
# done < $FTPLOG_SORT

# printf " $name\n" | tee -a $FTPLOG_PARSED