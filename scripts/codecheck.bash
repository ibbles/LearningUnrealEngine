#!/bin/bash

# Look for code style violations in snippets.


echo -e "\nFiles with tabs:"
for file in *.md ; do
	with_tab=$(grep -P '\t' "${file}")
	if [ -n "${with_tab}" ] ; then
		echo -e "# $file #\n$with_tab"
	fi
done

# These can be fixed with:
# for f in *.md
#      sed -i 's,\t,    ,g' "$f"
# end


echo -e "\nFiles with white-space-only lines:"
for file in *.md ; do
	with_whitespace_only=$(grep -En "^[[:blank:]]+\$" "${file}")
	if [ -n "${with_whitespace_only}" ] ; then
		echo -e "# $file #\n$with_whitespace_only"
	fi
done

# These can be fixed with:
# for f in *.md
#     $(sed -i -e 's,^\s\+$,,g' "%f"
# end


# Markdown uses double-space at the end of a line to create a line break
# so we can't just flag all trailing spaces. To do this properly we need
# a Markdown parser that can help us find the code blocks.
echo -e "\nFiles with excessive trailing white-space lines:"
for file in *.md ; do
	with_trailing_whitespace=$(grep -En "[[:blank:]][[:blank:]][[:blank:]]+\$" "${file}" | grep -Ev "\[.*\]\(.*\)")
	if [ -n "${with_trailing_whitespace}" ] ; then
		echo -e "# $file #\n$with_trailing_whitespace"
	fi
done

# TODO: Write a sed command to fix these as well.
