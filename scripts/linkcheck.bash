#!/bin/bash


# Look for broken links to other documents.
# A link has the following form, where ℕ denotes a digit and α a sequence of printable character:
#  [[ℕℕℕℕ-ℕℕ-ℕℕ_ℕℕ:ℕℕ:ℕℕ]] [α](./α.md)
#
# Failure cases:
# - Link points to a file that does not exist.
# - Link is not a relative link, i.e., does not start with './'.
# - Link does not point to a Markdown document, i.e., does not end with '.md'.
# - Link contains spaces.
#
# Special cases that are allowed:
# - Character immediately preceeding the link, i.e., '.[doc](./doc.md)'.
# - Character immediately following the link, i.e., '[doc](./doc.md).'.
# - Lambdas in C++ code, i.e., '[thi](const FDoneDelegate& Done)'.

echo -e "Files that contain broken local links:"
for source in *.md ; do
    sed -nr 's,\[\[[0-9_:-]+\]\] \[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n\[\[[0-9_:-]+\]\] \[[^][()]+\]\(([^][()]+)\)[^\n]*,\1\n,pg' "${source}" | \
        while read link ; do
            if [ -z "${link}" ] ; then
                continue
            fi
            if [[ "${link}" =~ " " ]] ; then
                echo "${source}: Space in link '${link}'."
            fi
            if [[ ! "${link}" =~ .md$ ]] ; then
                echo "${source}: No .md suffix in link '${link}'."
            fi
            if [[ ! "${link}" =~ ^./ ]] ; then
                echo "${source}" "No ./ prefix in link '${link}'."
            fi
            target=$(echo "$link" | sed 's,%20, ,g')
            if [ ! -f "${target}" ] ; then
                echo "${source}: Broken link '$link'."
            fi
        done
done

echo -e "\n"


echo "Files with contain incorrect ID-links to other documents:"
for source in *.md ; do
    sed -nr 's,.*\[\[(.*)\]\].*,\1,pg' "${source}" | \
        while read link ; do
            if echo "${link}" | grep -qvE  "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]:[0-9][0-9]:[0-9][0-9]" ; then
                echo "  ${source}: Invalid ID-link '${link}'."
            fi
        done
done

echo -e "\n"

echo "Files that contains link lists without trailing double-space:"
for file in *.md ; do
    no_space=$(sed -nr  's,^\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+.*\]\] \[.*\]\((.*)\)$,\1,p' "$file")
    if [ -n "${no_space}" ] ; then
        echo -e "  $file: $no_space"
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

echo -e "\n\n"
echo "Lots of link errors in Basic project setup.md."
echo "Make this script find those."
