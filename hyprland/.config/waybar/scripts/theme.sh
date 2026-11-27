#!/usr/bin/env bash
# Переключить тему waybar: theme.sh <имя> | theme.sh (список). Темы — ~/.config/waybar/themes/*.css
dir=~/.config/waybar
if [ -z "$1" ]; then
  cur=$(grep -oP 'themes/\K[^.]+' "$dir/style.css")
  for f in "$dir"/themes/[!_]*.css; do n=$(basename "$f" .css); [ "$n" = "$cur" ] && echo "* $n" || echo "  $n"; done
  exit 0
fi
[ -f "$dir/themes/$1.css" ] || { echo "no such theme: $1"; exit 1; }
printf '/* Активная тема waybar. Переключать: ~/.config/waybar/scripts/theme.sh <имя> */\n@import url("themes/%s.css");\n' "$1" > "$dir/style.css"
pkill -SIGUSR2 waybar
echo "theme: $1"
