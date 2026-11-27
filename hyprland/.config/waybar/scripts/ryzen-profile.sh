#!/usr/bin/env bash
# Кнопка пресетов ryzen-profile для waybar (замена плагина noctalia local/ryzen_profile).
# Без аргументов — вывести JSON с текущим пресетом; next|prev — переключить.
CONF=/etc/ryzenadj.conf
case "$1" in
  next|prev)
    if sudo -n /usr/local/bin/ryzen-profile "$1" >/dev/null 2>&1; then
      p=$(grep -oP '^PROFILE=\K\w+' "$CONF")
      noctalia msg notification-show "Ryzen Profile" "${p^^}" >/dev/null 2>&1
    else
      noctalia msg notification-show "Ryzen Profile" "Failed to switch profile" >/dev/null 2>&1
    fi
    pkill -RTMIN+8 waybar
    exit 0 ;;
esac
p=$(grep -oP '^PROFILE=\K\w+' "$CONF" 2>/dev/null)
case "$p" in
  eco)         t="ECO";  i="󰌪"; tip="ECO — 8 W, up to 1800 MHz" ;;
  balanced)    t="BAL";  i="󰊚"; tip="BALANCED — 12 W, up to 2500 MHz" ;;
  performance) t="PERF"; i="󱓞"; tip="PERFORMANCE — 15 W, up to 3200 MHz" ;;
  *)           t="?";    i="";  tip="не удалось прочитать $CONF"; p=unknown ;;
esac
printf '{"text":"%s %s","tooltip":"%s\\nClick: next · Right-click: previous","class":"%s"}\n' "$i" "$t" "$tip" "$p"
