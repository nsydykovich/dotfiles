#!/usr/bin/env bash
# monitor-rotate.sh — автоповорот встроенного монитора по акселерометру
# Зависимости: iio-sensor-proxy (даёт monitor-sensor)

INTERNAL="eDP-1"
SCALE="1.2"
LOGFILE="/tmp/monitor-rotate.log"
LOCKFILE="/tmp/monitor-rotate.lock"

# Устройства, координаты которых нужно крутить вручную вместе с монитором
# (автоматический ремап Hyprland'ом для них не срабатывает)
INPUT_DEVICES=(
    "elan2514:00-04f3:2b11"
    "elan2514:00-04f3:2b11-stylus"
)

# Тачпад физически не вращается вместе с экраном — его transform
# всегда держим в 0, иначе курсор перестаёт двигаться как ожидается.
TOUCHPAD="syna32a1:00-06cb:ce17-touchpad"

log() {
    echo "[$(date '+%H:%M:%S')] $*" >> "$LOGFILE"
}

# Защита от двойного запуска: если другой экземпляр уже работает — выходим
exec 9>"$LOCKFILE"
if ! flock -n 9; then
    log "уже запущен — выхожу (PID $$)"
    exit 0
fi

log "=== запуск listener'а PID=$$"

is_internal_active() {
    hyprctl monitors -j | jq -e --arg n "$INTERNAL" '.[] | select(.name == $n)' >/dev/null
}

apply_transform() {
    local transform="$1"
    if ! is_internal_active; then
        log "встроенный отключён — пропускаем поворот ($transform)"
        return
    fi
    log "применяю transform=$transform к $INTERNAL"
    hyprctl eval 'hl.monitor({ output = "'"$INTERNAL"'", mode = "preferred", position = "auto", scale = "'"$SCALE"'", transform = '"$transform"', disabled = false })'

    for dev in "${INPUT_DEVICES[@]}"; do
        log "применяю transform=$transform к input $dev"
        hyprctl eval 'hl.device({ name = "'"$dev"'", transform = '"$transform"' })'
    done

    log "фиксирую transform=0 у тачпада $TOUCHPAD"
    hyprctl eval 'hl.device({ name = "'"$TOUCHPAD"'", transform = 0 })'
}

# stdbuf -oL форсирует line-buffering у monitor-sensor чтобы события приходили сразу
stdbuf -oL monitor-sensor | while IFS= read -r line; do
    case "$line" in
        *"Accelerometer orientation changed"*)
            ORIENTATION="${line##*: }"
            ORIENTATION="${ORIENTATION%% *}"
            log "raw='$line' -> ORIENTATION='$ORIENTATION'"

            case "$ORIENTATION" in
                normal)     TRANSFORM=0 ;;
                left-up)    TRANSFORM=1 ;;
                bottom-up)  TRANSFORM=2 ;;
                right-up)   TRANSFORM=3 ;;
                *)
                    log "неизвестная ориентация: '$ORIENTATION' — игнорирую"
                    continue
                    ;;
            esac

            apply_transform "$TRANSFORM"
            ;;
    esac
done
