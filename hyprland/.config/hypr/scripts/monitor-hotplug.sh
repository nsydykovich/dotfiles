#!/usr/bin/env bash
# monitor-hotplug.sh — вызывается при подключении/отключении монитора
# Использование: monitor-hotplug.sh [added|removed|check]

INTERNAL="eDP-1"
EVENT="${1:-check}"  # added | removed | check
LOCKFILE="/tmp/monitor-hotplug.lock"
LOGFILE="/tmp/monitor-hotplug.log"

log() {
    echo "[$(date '+%H:%M:%S')] $*" >> "$LOGFILE"
}

log "=== запуск: EVENT=$EVENT PID=$$"

# Если уже выполняется — выходим, не создаём цикл
exec 9>"$LOCKFILE"
if ! flock -n 9; then
    log "заблокирован (уже выполняется), выход"
    exit 0
fi

log "лок получен"

apply_monitors() {
    local monitors_json
    monitors_json=$(hyprctl monitors all -j)
    log "monitors json: $monitors_json"

    external_count=$(echo "$monitors_json" | \
        jq --arg int "$INTERNAL" '[.[] | select(.name != $int)] | length')

    log "external_count=$external_count"

    if [ "$external_count" -gt 0 ]; then
        log "внешний есть — отключаем встроенный"
        hyprctl eval 'hl.monitor({ output = "'"$INTERNAL"'", disabled = true })'
        echo "Xft.dpi: 96" | xrdb -merge
        notify-send "Монитор" "Внешний подключён, встроенный отключён"
    else
        log "только встроенный — включаем"
        sleep 1.5
        hyprctl eval 'hl.monitor({ output = "'"$INTERNAL"'", mode = "preferred", position = "auto", scale = "1.25", disabled = false })'
        echo "Xft.dpi: 120" | xrdb -merge
        notify-send "Монитор" "Только встроенный, scale 1.25"
    fi
}

case "$EVENT" in
    added)
        sleep 1.75
        apply_monitors
        ;;
    removed)
        sleep 0.5
        apply_monitors
        ;;
    check|*)
        apply_monitors
        ;;
esac

log "=== завершён: EVENT=$EVENT"
