#!/usr/bin/env python3
"""Перекраска Kvantum-темы ColloidDark (Colloid-kde) в палитру AncientAliens.
Запуск: python3 recolor.py  -> ~/.config/Kvantum/ColloidAliens/
"""
import os, re, pathlib
SRC = pathlib.Path.home() / "rice/themes/Colloid-kde/Kvantum/Colloid"
DST = pathlib.Path.home() / ".config/Kvantum/ColloidAliens"

# kvconfig: роли Qt-палитры
KV = {
    "#2c2c2c": "#09111c",  # window / base = surface Noctalia
    "#2e2e2e": "#0c1621",  # alt.base
    "#4d4d4d": "#203547",  # button
    "#535353": "#2d485b",  # light
    "#474747": "#263f52",  # mid.light
    "#282828": "#070f19",  # dark
    "#323232": "#13202d",  # mid = surface_container Noctalia
    "#5b9bf8": "#3e6f92",  # highlight (белый текст поверх -> нужен тёмный акцент)
    "#dfdfdf": "#d6e6f2",  # text
    "#696969": "#507284",  # disabled text
    "#efefef": "#e3edf5",  # tooltip text
    "#ffffff": "#eef5fa",  # highlight text
    "#787878": "#6b8799",
    "#0057ae": "#7fd0e0",  # link
    "#e040fb": "#a9b4e8",  # visited link
}
# svg: отрисовка виджетов
SVG = {
    "#2c2c2c": "#09111c", "#414141": "#1c2d3d", "#242424": "#070f19", "#1a1a1a": "#050a12",
    "#c1c1c1": "#a9bccb", "#5b9bf8": "#6fa6cc", "#dfdfdf": "#d6e6f2", "#b74aff": "#a9b4e8",
    "#989898": "#8fa6b8", "#31363b": "#13202d", "#3c3c3c": "#203547", "#f04a50": "#e88a8a",
    "#eff0f1": "#e3edf5", "#93cee9": "#aad5f0", "#4285f4": "#6fa6cc", "#3daee9": "#7fd0e0",
    "#fcfcfc": "#f6f9fb", "#5a5a5a": "#3e5c70", "#d1d1d1": "#c3d2de", "#b6b6b6": "#a9bccb",
    "#acb1bc": "#a9bccb", "#666666": "#507284", "#646464": "#507284", "#5a616e": "#3e5c70",
    "#26272a": "#070f19", "#212121": "#060c15", "#1e1e1e": "#070f19",
}
def recolor(text, table):
    def sub(m):
        h = m.group(0).lower()
        return table.get(h, m.group(0))
    return re.sub(r"#[0-9a-fA-F]{6}(?![0-9a-fA-F])", sub, text)

DST.mkdir(parents=True, exist_ok=True)
kv = (SRC / "ColloidDark.kvconfig").read_text()
kv = recolor(kv, KV).replace("#333\"", "#13202d\"")
(DST / "ColloidAliens.kvconfig").write_text(kv)
svg = (SRC / "ColloidDark.svg").read_text()
svg = recolor(svg, SVG).replace("#333\"", "#13202d\"")
(DST / "ColloidAliens.svg").write_text(svg)
left = sorted(set(h.lower() for h in re.findall(r"#[0-9a-fA-F]{6}(?![0-9a-fA-F])", svg)) - set(SVG.values()) - {"#ffffff", "#000000"})
print("готово:", DST, "| незаменённые цвета svg:", left or "нет")
