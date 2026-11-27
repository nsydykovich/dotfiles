#!/usr/bin/env python3
"""Waybar <-> Noctalia bridge. State comes from Noctalia (`noctalia msg` IPC and its cache); clicks go back to it.

  noctalia-bridge.py <module>           -> JSON for a waybar custom module
  noctalia-bridge.py <module> toggle    -> toggle via Noctalia and refresh modules by signal
  noctalia-bridge.py <module> quiet     -> same as plain, but "off" yields empty text (module hidden)

Modules: weather, wifi, bluetooth, dnd, night, caffeine
"""
import json, os, subprocess, sys, time
from datetime import datetime

SIG = 10                      # все модули моста обновляются по SIGRTMIN+10
CAFFEINE = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "waybar-caffeine")  # у noctalia нет геттера
WEATHER = os.path.expanduser("~/.cache/noctalia/weather.json")

def msg(*a):
    try:
        return subprocess.run(["noctalia", "msg", *a], capture_output=True, text=True, timeout=3).stdout.strip()
    except Exception:
        return ""

def out(text, tooltip="", cls=""):
    print(json.dumps({"text": text, "tooltip": tooltip, "class": cls, "alt": cls}, ensure_ascii=False))

# --- погода (WMO-коды open-meteo -> Material Design иконки) ---
def wicon(code, day=True):
    if code == 0:              return "\U000F0599" if day else "\U000F0594"
    if code in (1, 2):         return "\U000F0595" if day else "\U000F0F31"
    if code == 3:              return "\U000F0590"
    if code in (45, 48):       return "\U000F0591"
    if 51 <= code <= 57:       return "\U000F0597"
    if 61 <= code <= 67 or 80 <= code <= 82: return "\U000F0596"
    if 71 <= code <= 77 or code in (85, 86): return "\U000F0598"
    if code >= 95:             return "\U000F0593"
    return "\U000F0590"

WDESC = {0: "clear", 1: "mostly clear", 2: "partly cloudy", 3: "overcast", 45: "fog", 48: "rime fog",
         51: "light drizzle", 53: "drizzle", 55: "heavy drizzle", 61: "light rain", 63: "rain", 65: "heavy rain",
         71: "light snow", 73: "snow", 75: "heavy snow", 77: "snow grains", 80: "showers", 81: "showers",
         82: "heavy showers", 85: "snow showers", 86: "heavy snow showers", 95: "thunderstorm", 96: "thunderstorm with hail", 99: "thunderstorm with hail"}
DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

def weather():
    try:
        s = json.load(open(WEATHER))["snapshot"]
        c = s["current"]
    except Exception:
        return out("\U000F0590 —", "Noctalia has not fetched the weather yet", "unknown")
    t = round(c["temperature_c"])
    code = c["weather_code"]
    lines = [f"<b>{s.get('location_name', '')}</b>",
             f"{WDESC.get(code, '')}, {t:+d}°, feels like {round(c['apparent_temperature_c']):+d}°",
             f"wind {c['wind_speed_kmh']:.0f} km/h · humidity {c['relative_humidity_percent']}%", ""]
    for d in s.get("forecast_days", [])[:5]:
        dt = datetime.fromisoformat(d["date_iso"])
        lines.append(f"<tt>{DAYS[dt.weekday()]} {dt.day:>2}</tt>  {wicon(d['weather_code'])}  "
                     f"{round(d['temperature_min_c']):+d}° … {round(d['temperature_max_c']):+d}°")
    age = int(time.time() - s.get("fetched_at", time.time())) // 60
    lines += ["", f"<small>Noctalia · updated {age} min ago</small>"]
    cls = "cold" if t <= 0 else ("hot" if t >= 28 else "mild")
    out(f"{wicon(code, c.get('is_day', True))}  {t:+d}°", "\n".join(lines), cls)

# --- переключатели ---
def caffeine_on():
    return os.path.exists(CAFFEINE)

def night_on():
    cfg = msg("config-get", "nightlight")
    return "enabled = true" in cfg or "force = true" in cfg

TOGGLES = {
    #  имя        (иконка вкл, иконка выкл, подпись, функция состояния, команда переключения)
    "wifi":      ("\U000F05A9", "\U000F05AA", "Wi-Fi",            lambda: msg("wifi-status") == "on",              ["wifi-toggle"]),
    "bluetooth": ("\U000F00AF", "\U000F00B2", "Bluetooth",        lambda: msg("bluetooth-status") == "on",         ["bluetooth-toggle"]),
    "dnd":       ("\U000F009B", "\U000F009A", "Do Not Disturb",   lambda: msg("notification-dnd-status") == "on",  ["notification-dnd-toggle"]),
    "night":     ("\U000F0594", "\U000F0599", "Night Light",      night_on,                                         ["nightlight-toggle"]),
    "caffeine":  ("\U000F0176", "\U000F0176", "Caffeine", caffeine_on,                               ["caffeine-toggle"]),
}
HINT = {"wifi": "Right-click: networks", "bluetooth": "Right-click: devices", "dnd": "Right-click: history", "night": "", "caffeine": ""}

def toggle_state(name, quiet=False):
    on_i, off_i, label, state, _ = TOGGLES[name]
    on = state()
    if quiet and not on:
        return out("", "", "off")
    tip = f"{label}: {'on' if on else 'off'}\nClick: toggle" + (f" · {HINT[name]}" if HINT[name] else "")
    out(on_i if on else off_i, tip, "on" if on else "off")

def toggle(name):
    msg(*TOGGLES[name][4])
    if name == "caffeine":
        if caffeine_on(): os.remove(CAFFEINE)
        else: open(CAFFEINE, "w").close()
    time.sleep(0.3)
    subprocess.run(["pkill", f"-RTMIN+{SIG}", "waybar"])

if __name__ == "__main__":
    name = sys.argv[1] if len(sys.argv) > 1 else ""
    if name == "weather":
        weather()
    elif name in TOGGLES:
        if sys.argv[2:] == ["toggle"]: toggle(name)
        else: toggle_state(name, quiet=sys.argv[2:] == ["quiet"])
    else:
        sys.exit(__doc__)
