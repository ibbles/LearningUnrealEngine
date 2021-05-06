#!/bin/bash

# Look for code style violations in snippets.


echo -e "Files with tabs:"
for file in *.md ; do
	with_tab=$(grep -P '\t' "${file}")
	if [ -n "${with_tab}" ] ; then
		echo -e "  # $file #\n$with_tab"
	fi
done

# These can be fixed with:
# for f in *.md
#      sed -i 's,\t,    ,g' "$f"
# end
