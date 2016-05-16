#!/bin/bash
# Script
# Name: Sync
# Description: Sync the Main directory with staging, either with an upstream push or downstream pull.
# Options:
#		-u | --upstream : Sync with an upstream push, meaning all changes in Main that aren't in staging get pushed to staging.
#		-d | --downstream : Sync with a downstream pull, meaning all changes in staging that aren't in Main get pulled to Main.

### TODO once a full configuration is set up, have this be restricted to the proper directories

### TOOD it needs to be dynamic to work with multiple branches

### TODO there needs to be a branch in .staging that is total garbage, it just exists to not block pushes to it

### TODO there needs to be an error if a message is not supplied.

branchName=$(git rev-parse --abbrev-ref HEAD)


# Push to .staging
echo "***Push to staging"
git push staging $branchName
cd ../.staging

# # Checkout correct branch
git checkout $branchName

# # Clean up project files to prepare for push to remote
echo "***Remove and replace .gitignore"
rm .gitignore
cp ../.ignores/ignore-project-files .
mv ignore-project-files .gitignore
echo "***Remove project files"
rm -rf .idea
find . -name '*.iml' | awk '{ print "\"" $0 "\"" }' ORS=' ' | xargs rm
echo "***Commit changes"
git add .
git commit -m "Commit to prepare directory for staging"

# Squash commits
# echo "***Squash commits"
# count=$(git log --oneline origin/master..master | wc -l | awk -F' ' '{ print $1 }')
# echo "Count: $count"
# git reset --soft HEAD~$count &&
# git commit -m "$1"

# Push to origin
# git push origin $branchName

# Checkout other branch
# git checkout other

# Return to Main to sync with .staging
# cd ../Main
# git pull staging $branchName --no-commit --no-ff

# # Push to origin
# echo "***Push to origin"
# git push origin master

# 1) Push everything as-is to .staging
# 2) Retrieve .gitignore from staging and replace .gitignore in Main
# 3) Remove .idea directory from Main
# 4) Remove all *.iml files from Main
# 5) Commit these changes.
# 6) Use git log --oneline remote/branch..branch | wc -l to get the commit diff with origin
# 7) Do a git reset --soft HEAD~{countFromLastCommand}
# 8) Make a commit with a good message for the remote
# 9) Push to the remote