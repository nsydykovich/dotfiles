#!/usr/bin/env bash
# Переключить раскладку waybar (конфиг + тема): layout.sh <classic|aliens|calm|one|main> | layout.sh (список)
dir=~/.config/waybar
declare -A THEME=([classic]=pills [aliens]=aliens [calm]=calm [one]=one [main]=main)
if [ -z "$1" ]; then
  cur=$(basename "$(readlink "$dir/config.jsonc")" .jsonc)
  for f in "$dir"/layouts/*.jsonc; do n=$(basename "$f" .jsonc); [ "$n" = "$cur" ] && echo "* $n" || echo "  $n"; done
  exit 0
fi
[ -f "$dir/layouts/$1.jsonc" ] || { echo "no such layout: $1"; exit 1; }
ln -sfn "layouts/$1.jsonc" "$dir/config.jsonc"
"$dir/scripts/theme.sh" "${THEME[$1]:-pills}" >/dev/null
pkill -x waybar; sleep 0.4
setsid -f waybar >~/.cache/waybar.log 2>&1
echo "layout: $1 (theme ${THEME[$1]:-pills})"
