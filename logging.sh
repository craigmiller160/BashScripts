#!/bin/sh

cutoff="05:00:00"
greater_than="false"

function find_cutoff {
	greater_than="false"
	IFS=$':'
	time_arr=($1)
	cut_arr=($cutoff)

	if [ ${time_arr[0]} -gt ${cut_arr[0]} ]; then
		if [ ${time_arr[1]} -gt ${cut_arr[1]} ]; then
			if [ ${time_arr[2]} -gt ${cut_arr[2]} ]; then
				greater_than="true"
			fi
		fi
	fi

	IFS=$' '
}


IFS=$'\n'
TIMESTAMPS=($(svn log --limit 5 | grep '^r[0-9]*' | awk -F'|' '{ print $3 }' | sed 's/^ //g; s/ $//g'))

for ts in ${TIMESTAMPS[@]}; do
	IFS=$' '
	TS_ARR=($ts)
	echo "Date: ${TS_ARR[0]} Time: ${TS_ARR[1]}"
	find_cutoff ${TS_ARR[1]}
	echo $greater_than
done