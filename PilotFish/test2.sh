#!/bin/bash
# Test2 Script

TEST1="Test1"
TEST2="Test2"

DEFAULT=()
DEPLOYMENTS=()

while IFS='' read -r line || [[ -n "$line" ]]; do
    key=$(echo $line | awk '{print $1}')
    value=$(echo $line | awk '{print $2}')
    case $key in)
		Deployment) ;;
	esac
done < eip-deployment.conf