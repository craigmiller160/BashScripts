# New Git script commands

# These are for pulling from the no-project-files branch to one that has project files
# git reset HEAD .gitignore
# git checkout --ours .gitignore
# git reset HEAD .idea
# git checkout .idea
# git status --porcelain | grep '.iml' | awk -F' ' '{ print $2 }' | xargs git reset HEAD
# git status --porcelain | grep '.iml' | awk -F' ' '{ print $2 }' | xargs git checkout

# These are for pulling from the project files branch to one that doesn't have project files
git reset HEAD .idea
rm -rf .idea
git status --porcelain | grep '.iml' | awk -F' ' '{ print $2 }' | xargs git reset HEAD
git status --porcelain | grep '.iml' | awk -F' ' '{ print $2 }' | xargs rm