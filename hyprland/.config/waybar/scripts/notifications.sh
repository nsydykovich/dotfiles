#!/usr/bin/env bash
# Колокольчик уведомлений noctalia: показывает состояние Do Not Disturb.
if [ "$(noctalia msg notification-dnd-status 2>/dev/null)" = "on" ]; then
  echo '{"text":"󰂛","tooltip":"Do Not Disturb: on\nClick: history · Right-click: DND off","class":"dnd"}'
else
  echo '{"text":"󰂚","tooltip":"Notifications\nClick: history · Right-click: DND on","class":"normal"}'
fi
