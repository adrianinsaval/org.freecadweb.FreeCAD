#!/bin/sh

# usagge:
# ./update-revision.sh refType gitRef
# refType can be either "commit", "branch" or "tag"
# gitRef can be a commit hash, a branch name or a tag name
# if no gitRef is provided refType is ignored and the latest
# commit from master branch is used

refType=$1
gitRef=$2

if [ -z "$refType" ]; then
    refType="commit"
fi

if [ -z "$gitRef" ]; then
    gitRef=$(curl -s https://api.github.com/repos/FreeCAD/FreeCAD/commits/master \
        | awk 'NR==2' | sed 's/  "sha": "//;s/",//')
fi

# get number of commits
revcount=$(($(curl -s \
    'https://api.github.com/repos/FreeCAD/FreeCAD/compare/120ca87015...'"$gitRef"''\
    | grep "ahead_by" | sed -s 's/ //g;s/"ahead_by"://;s/,//')+1))

# replace values
sed -i '/revcount=/!b;s/=.*/='"$revcount"'/' org.freecadweb.FreeCAD.yaml
    sed -i '/url:.*FreeCAD.git/!b;n;s/[ctb].*/'"$refType"': '"$gitRef"'/' \
    org.freecadweb.FreeCAD.yaml
