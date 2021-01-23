#!/bin/bash


# Look for broken links to other documents.
# A link has the following form, where ℕ denotes a digit and α a sequence of printable character:
#  [[ℕℕℕℕ-ℕℕ-ℕℕ_ℕℕ:ℕℕ:ℕℕ]] [α](./α.md)
#

echo -e "Files that contain broken local links:"

for source in *.md ; do
    #sed -nr 's,\[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n(\[[^][()]+\]\([^][()]+\))[^\n]*,\1\n,g;s,\[[^][()]+\]\(([^][()]+)\),\1,pg' "${source}" |
    #sed -nr 's,\[\[[0-9_:-]+\]\] \[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n\[\[[0-9_:-]+\]\] (\[[^][()]+\]\([^][()]+\))[^\n]*,\1\n,g;s,\[[^][()]+\]\(([^][()]+)\),\1,pg' "${source}" |
    sed -nr 's,\[\[[0-9_:-]+\]\] \[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n\[\[[0-9_:-]+\]\] (\[[^][()]+\]\([^][()]+\))[^\n]*,\1\n,g;s,.*\[[^][()]+\]\(([^][()]+)\),\1,pg' "${source}" | \
        while read link ; do
            if [ -z "${link}" ] ; then
                continue
            fi
            if [[ "${link}" =~ ^http ]] ; then
                continue
            fi
            if [[ "${link}" =~ " " ]] ; then
                echo "${source}: Space in link '${link}'."
            fi
            #echo "'$link'"
            target=$(echo "$link" | sed 's,%20, ,g')
            if [ ! -f "${target}" ] ; then
                echo "${source}: Broken link '$link'."
            fi
        done
done

echo -e "\n"

echo "Files that contains link lists without trailing double-space:"
for file in *.md ; do
    no_space=$(sed -nr  's,^\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+.*\]\] \[.*\]\((.*)\)$,\1,p' "$file")
    if [ -n "${no_space}" ] ; then
        echo -e "$file:\n $no_space"
    fi
done

echo -e "\n"

echo "Files that contains links to images that doesn't exist:"
for file in *.md ; do
    images=$(sed -nr  's,^!\[.*\]\((.*)\)$,\1,p' "$file")
    if [ -z "${images}" ] ; then
        continue
    fi

    for image in $images ; do
        if [ ! -f "${image}" ] ; then
            echo "Image ${image} does not exist."
        fi
    done
done
