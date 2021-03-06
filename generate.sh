#!/usr/bin/env bash

HEADER=$'/**\n * Generated stub declarations for Advanced Custom Fields Pro.\n * https://www.advancedcustomfields.com/\n */'

FILE="acf-pro-stubs.php"

Fix_phpdoc()
{
    # - Fix type and variable name order for @param
    # - Remove remaining parentheses for @param
    # - Fix type and variable name order for @return
    # - Remove remaining parentheses for @return
    # - Fix "void"
    find ./ -type f -name $FILE -exec sed \
        -e 's#^\(\s*/\*\)$#\1*#' \
        -e 's#^\(\s*\*\s*@param\s\+\)\(\$\S\+\)\s\+(\(\S\+\))\(.*\)$#\1\3 \2\4#' \
        -e 's#^\(\s*\*\s*@param\s\+\)(\(\S\+\))\(.*\)$#\1\2\3#' \
        -e 's#^\(\s*\*\s*@return\s\+\)\(\$\S\+\)\s\+(\(\S\+\))\(.*\)$#\1\3 \2\4#' \
        -e 's#^\(\s*\*\s*@return\s\+\)(\(\S\+\))\(.*\)$#\1\2\3#' \
        -e 's#n/a#void#i' \
        -i "{}" ";"
}

"$(dirname $0)/vendor/bin/generate-stubs" \
  --finder=finder.php \
  --out="$FILE" \
  --force \
  --header="$HEADER" \
  --nullify-globals

Fix_phpdoc

# Shim the global $wpdb declaration, since it's actually set up inside a
# function call.
# echo $'\n/**\n * WordPress database abstraction object.\n * @var wpdb\n */\n$wpdb = null;' >> $FILE

# Trim tailing whitespace.  Not using sed because it seemed to struggle with
# some characters in the file.
perl -i -lpe "s/[[:space:]]+$//g" $FILE

rm "$FILE.bak"
