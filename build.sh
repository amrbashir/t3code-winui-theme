#!/usr/bin/env bash
# Builds winui.json from src/theme.json and src/theme.css.
set -euo pipefail
cd "$(dirname "$0")"

tab=$(printf '\t')
theme=$(tr -d '\r' < src/theme.json)
css=$(tr -d '\r' < src/theme.css)

{
  # theme.json without its closing brace, ready for one more property
  printf '%s\n' "$theme" | sed -e '$d' | sed -e '$s/$/,/'
  printf '  "css": "'
  printf '%s\n' "$css" |
    sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e "s/$tab/\\\\t/g" |
    awk '{ printf "%s\\n", $0 }'
  printf '"\n}\n'
} > winui.json.tmp
mv winui.json.tmp winui.json

echo "Built winui.json"
