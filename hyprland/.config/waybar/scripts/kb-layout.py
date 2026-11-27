#!/usr/bin/env python3
"""Раскладка для waybar: US / RU. Слушает событие activelayout в socket2 Hyprland, печатает JSON на каждую смену.
(Встроенный hyprland/language в waybar 0.16 игнорирует format-<lang>, поэтому свой модуль.)"""
import json, os, socket, subprocess, sys

NAMES = {"English": "US", "Russian": "RU"}

def short(keymap):
    for k, v in NAMES.items():
        if keymap.startswith(k):
            return v
    return keymap[:2].upper()

def emit(keymap):
    print(json.dumps({"text": short(keymap), "tooltip": keymap, "class": short(keymap).lower()}), flush=True)

def current():
    try:
        kbs = json.loads(subprocess.run(["hyprctl", "devices", "-j"], capture_output=True, text=True).stdout)["keyboards"]
        main = next((k for k in kbs if k.get("main")), kbs[0])
        return main["active_keymap"]
    except Exception:
        return "?"

emit(current())
sock = os.path.join(os.environ["XDG_RUNTIME_DIR"], "hypr", os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket2.sock")
s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM); s.connect(sock)
buf = b""
while True:
    data = s.recv(4096)
    if not data:
        sys.exit(1)
    buf += data
    *lines, buf = buf.split(b"\n")
    for line in lines:
        if line.startswith(b"activelayout>>"):
            emit(line.decode(errors="replace").split(",", 1)[-1])   # activelayout>>KEYBOARD,LAYOUT
