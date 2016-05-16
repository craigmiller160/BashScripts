#!/bin/bash
# Script to create new local branch

# Core variables that define the locations of all directories
DEV_ROOT="/Users/craigmiller/NewTestDev"
DEV_MAIN="$DEV_ROOT/Main"
PROJECT="$DEV_ROOT/.project"
TEMPLATE="$DEV_ROOT/.template"
LOGS="$DEV_ROOT/.logs"
LOG_FILE="$LOGS/create.log"

### TODO ensure on master branch in Main directory before beginning process
### TODO be able to handle it if the local branch or directory already exists

### TODO revise this section that produces an error if not enough arguments
if [ $# -lt 1 ]; then
	echo "Error! Not enough arguments for the script"
	exit 1
fi

NAME="$1"

### TODO put this logs creating code in a better place
if [ ! -d "$LOGS" ]; then
	mkdir -p "$LOGS"
fi

exec 3>&1 1>>"${LOG_FILE}" 2>&1
if [ -f "$LOG_FILE" ]; then
	> "$LOG_FILE"
else
	touch "$LOG_FILE"
fi

cd "$DEV_MAIN"

echo "Creating new local git branch" | tee /dev/fd/3
git branch "$NAME" 1>/dev/null

echo "Creating and configuring new branch directory" | tee /dev/fd/3
echo "   Copying .template to create new directory"
cp -R "$TEMPLATE" "$DEV_ROOT/$NAME"
echo "   Initializing and configuring git in new directory"
cd "$DEV_ROOT/$NAME"
git init 1>/dev/null
git remote add origin "$DEV_MAIN"
echo "   Pulling data from git origin to new directory"
git pull origin "$NAME" 1>/dev/null
git branch -u origin/"$NAME" 1>/dev/null