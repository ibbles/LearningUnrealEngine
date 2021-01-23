#!/bin/bash


# Look for broken links to other documents.
# A link has the following form, where ℕ denotes a digit and α a sequence of printable character:
#  [[ℕℕℕℕ-ℕℕ-ℕℕ_ℕℕ:ℕℕ:ℕℕ]] [α](./α.md)
#
# At first there were a large number of broken links following the same pattern
# so here we collapse duplicates to a single error message. Now that most broken
# links has been fix we might want to rewrite this to the same kind of
# one-file-at-the-time form as the other checks.
# echo "Links to files that doesn't' exist:"
# links=$(sed -nr  's,\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+\]\] \[.*\]\(([a-zA-Z0-9_%./]+)\),\1,p' *.md | sort | sort -u)
# #links=$(sed -nr  's,\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+\]\] \[.*\]\((.*)\),\1,p' *.md | sort | sort -u)

# echo "Matches:"
# echo $links

# for link in $links ; do
#     file=$(echo "$link" | sed 's,%20, ,g')
#     #echo "Checking link $link."
#     #[[ -f "$link" ]] && echo "$link good" || echo "$link is bad"
#     if [ ! -f "$file" ] ; then
#         echo -e "\nA broken link:"
#         echo "$link"
#         echo -e "\nEnd of link."
#     fi
# done


echo -e "\n\nExperiment:"

# sed -nr 's,\[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n(\[[^][()]+\]\([^][()]+\))[^\n]*,\1\n,pg' "C++ Pawn.md" | \

for source in *.md ; do
    sed -nr 's,\[[^][()]+\]\([^][()]+\),\n&,g;s,[^\n]*\n(\[[^][()]+\]\([^][()]+\))[^\n]*,\1\n,g;s,\[[^][()]+\]\(([^][()]+)\),\1,pg' "${source}" | \
        while read link ; do
            if [ -z "${link}" ] ; then
                continue
            fi
            if [[ "${link}" =~ ^http ]] ; then
                continue
            fi
            #echo "'$link'"
            target=$(echo "$link" | sed 's,%20, ,g')
            if [ ! -f "${target}" ] ; then
                echo "${source}: Broken link '$link'."
            fi
        done
done

echo -e "Experiment done\n"

echo "Files that contain broken document links:"
for source in *.md ; do
    sed -nr  's,\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+\]\] \[.*\]\(([^)]+)\),\1,p' "${source}" | \
        while read link ; do
            if [[ "${link}" =~ " " ]] ; then
                echo "${source}: Space in link '${link}'."
            fi
            target=$(echo "$link" | sed 's,%20, ,g')
            if [ ! -f "${target}" ] ; then
                echo "${source}: Broken link '$link'."
            fi
        done

    #links=$(sed -nr  's,\[\[[0-9]+-[0-9]+-[0-9]+_[0-9]+:[0-9]+:[0-9]+\]\] \[.*\]\(([a-zA-Z0-9_%./]+)\),\1,p' "${source}")
    # echo $links
    # old_ifs=$IFS
    # IFS=$'\n'
    # for link in $links ; do
    #     if [ ! -f "$link" ] ; then
    #         echo "$source: '$link'"
    #     fi
    # done
    # IFS=$old_ifs
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
