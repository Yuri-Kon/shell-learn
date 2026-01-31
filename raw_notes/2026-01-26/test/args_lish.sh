#!/usr/bin/env bash
set -- "arg1" "arg 2" "arg3"

echo "args in \$@ :"
printf '<%s>\n' $@

echo "================"

echo "args in \$* :"
printf '<%s>\n' $*

echo "================"
echo "args in \$@ with quoting :"
printf '<%s>\n' "$@"

echo "================"
echo "args in \$* with quoting :"
printf '<%s>\n' "$*"
