#!/usr/bin/env python3
"""ColloidDark.colors (Colloid-kde) -> ColloidAliens.colors в палитре AncientAliens."""
import re, pathlib
SRC = pathlib.Path.home() / "rice/themes/Colloid-kde/color-schemes/ColloidDark.colors"
DST = pathlib.Path.home() / ".local/share/color-schemes/ColloidAliens.colors"
MAP = {
    "33,33,33": "19,32,45", "36,36,36": "7,15,25", "43,43,43": "8,16,26", "44,44,44": "9,17,28",
    "46,46,46": "12,22,33", "55,55,55": "16,27,39", "56,56,56": "16,27,39", "61,61,61": "19,32,45",
    "66,66,66": "28,45,61", "71,71,71": "45,72,91", "85,85,85": "62,92,112", "112,111,110": "80,114,132",
    "120,120,120": "107,135,153", "127,140,141": "107,135,153", "136,136,136": "143,166,184",
    "171,171,171": "169,188,203", "189,195,199": "195,210,222", "222,222,222": "214,230,242",
    "252,252,252": "246,249,251", "255,255,255": "238,245,250",
    "91,155,248": "170,213,240",                      # акцент #aad5f0 (фокус, hover, ссылки)
    "246,116,0": "232,168,124", "39,174,96": "159,212,176", "218,68,83": "232,138,138",
    "237,21,21": "232,138,138", "201,206,59": "230,207,148", "17,209,22": "159,212,176",
    "253,188,75": "230,207,148", "79,127,239": "143,184,222", "61,174,233": "127,208,224",
    "41,128,185": "111,166,204", "130,156,239": "169,180,232", "128,152,239": "169,180,232",
}
SELECTION_BG = "62,111,146"   # #3e6f92: под выделением белый текст, бледный акцент не читается
out, sec = [], None
for line in SRC.read_text().splitlines():
    m = re.match(r"^\[(.+)\]$", line)
    if m: sec = m.group(1)
    elif "=" in line:
        k, v = line.split("=", 1)
        v = MAP.get(v, v)
        if sec == "Colors:Selection" and k in ("BackgroundNormal", "BackgroundAlternate"): v = SELECTION_BG
        if sec == "Colors:View" and k == "BackgroundNormal": v = "9,17,28"   # фон списков = фон окна = surface Noctalia
        if k == "Name": v = "ColloidAliens"
        line = f"{k}={v}"
    out.append(line)
DST.write_text("\n".join(out) + "\n")
left = {v for v in re.findall(r"=(\d+,\d+,\d+)$", "\n".join(out), re.M)} - set(MAP.values()) - {SELECTION_BG}
print("готово:", DST, "| незаменённые:", left or "нет")
