#! /bin/bash
#VERSIONS_FILE=_data/versions.csv
#VERSION_PAGES_LOCATION=pages/versions
#TEMPLATES_LOCATION=.github/templates

echo -e "version\nlatest" >$VERSIONS_FILE
find ./docs -maxdepth 1 -type d -printf '%P\n' | grep -P "\d+\.\d+\.\d+.*" | sed '/-/!{s/$/_/}' | sort -rV | sed 's/_$//' >>$VERSIONS_FILE

readarray -t VERSIONS <<<$(cat $VERSIONS_FILE)

mkdir -p $VERSION_PAGES_LOCATION
rm $VERSION_PAGES_LOCATION/*

idx=0
for version in "${VERSIONS[@]:1}"; do
    for file in $TEMPLATES_LOCATION/*.md; do
        target_file=${file/"$TEMPLATES_LOCATION"/"$VERSION_PAGES_LOCATION"}
        target_file=${target_file/VERSION/"$version"}
        cp $file $target_file
        sed -i s/VERSION/"$version"/g $target_file
        sed -i s/ORDER/"$idx"/g $target_file
        echo "Created page $target_file"
    done
    idx=$((idx + 1))
done
