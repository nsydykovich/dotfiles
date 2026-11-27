#!/usr/bin/env bash
# Слушает события Hyprland и реагирует только на HDMI события

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

socat UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | \
while IFS= read -r line; do
    case "$line" in
        monitoradded\>\>HDMI*)
            "$SCRIPT_DIR/monitor-hotplug.sh" added
            ;;
        monitorremoved\>\>HDMI*)
            "$SCRIPT_DIR/monitor-hotplug.sh" removed
            ;;
    esac
done
