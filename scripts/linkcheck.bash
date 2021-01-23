#!/bin/bash


echo "Links to files that doesn't' exist:"
links=$(sed -nr  's,^\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+.*\]\] \[.*\]\((.*)\),\1,p' *.md | sort | sort -u)
for link in $links ; do
    file=$(echo "$link" | sed 's,%20, ,g')
    #echo "Checking link $link."
    #[[ -f "$link" ]] && echo "$link good" || echo "$link is bad"
    [[ -f "$file" ]] || echo "$link"
done

echo -e "\n"

echo "Files that contains link lists without trailing double-space:"
for file in *.md ; do
    #no_space=$(sed -nr  's,\[\[.*\]\] \[.*\]\((.*)\)$,\1,p' "$file")
    no_space=$(sed -nr  's,^\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+.*\]\] \[.*\]\((.*)\)$,\1,p' "$file")
    if [ -n "${no_space}" ] ; then
        echo -e "$file:\n $no_space"
    fi
done
