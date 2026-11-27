# hyprland — AncientAliens rice

Hyprland 0.57 (Lua config) · waybar · Noctalia v5 · Colloid GTK/Kvantum, all recolored to one steel-blue palette (**AncientAliens**).

| Role | Tool |
|---|---|
| Compositor | Hyprland ≥ 0.55 (`hyprland.lua`) |
| Bar | waybar (`layouts/main.jsonc` + `themes/main.css`) |
| Shell (launcher, notifications, OSD, lockscreen, control center) | Noctalia v5, its own bar disabled |
| GTK 3/4 + libadwaita | Colloid-Dark-Aliens (patched Colloid, see `themes/`) |
| Qt / KDE apps | Kvantum `ColloidAliens` + `ColloidAliens.colors` |
| Terminal | Ghostty (colors from Noctalia template) |

## Palette

| | hex |
|---|---|
| background | `#09111c` |
| surface / cards | `#13202d` |
| border | `#2d485b` |
| text | `#d6e6f2` |
| accent | `#aad5f0` |

Single source: `.config/noctalia/palettes/AncientAliens.json`.

## Install

```sh
cd ~/dotfiles
stow hyprland          # symlinks .config/* and .local/share/* into $HOME
```

`README.md` and `themes/` are ignored by stow (`.stow-local-ignore`).

Then:
- **GTK theme**: clone [Colloid-gtk-theme](https://github.com/vinceliuice/Colloid-gtk-theme) at the commit in `themes/colloid-gtk-aliens.patch.base`, `git apply themes/colloid-gtk-aliens.patch`, run `./install.sh -c dark -l --tweaks aliens`.
- **Noctalia**: set your city in `.config/noctalia/config.toml` (`[location] address`), enable plugins: `noctalia msg plugins enable local/ryzen_profile local/power_draw`.
- **Optional**: `ryzen_profile` plugin and waybar power widget expect `ryzenadj` + `ryzen_smu` (Ryzen laptops); the profile switcher calls `sudo -n /usr/local/bin/ryzen-profile`.

## Layout

```
.config/hypr/
├── hyprland.lua          entry point, sets package.path, requires modules
├── env.lua  autostart.lua
├── appearance/           general, decoration, animations, layouts, misc
├── input/                keyboard (us,ru), mouse, touchpad, gestures
├── keybindings/          windows, focus, workspaces, media, screenshots
├── monitors/             defaults, hotplug, lid
├── rules/                window, layer (waybar blur), workspace (1–10 persistent), xwayland fixes
└── scripts/              monitor hotplug / rotate
.config/waybar/
├── config.jsonc -> layouts/main.jsonc     switch: scripts/layout.sh <main|calm|one|aliens|classic>
├── layouts/  themes/                      one theme per layout, shared themes/_palette.css
└── scripts/                               noctalia-bridge.py, power.py (PPT via ryzen_smu), kb-layout.py
.config/noctalia/         config.toml, hooks.toml (lockscreen → US layout), palettes/
.local/share/noctalia/plugins/   ryzen_profile, power_draw
```

## Bar (waybar `main`)

`launcher · ●●━●●●●●●● · CPU RAM temp W · window title`  —  `h:MM AM/PM`  —  `tray · clipboard layout · volume battery Wi-Fi · notifications control-center`

All clicks open Noctalia panels (`noctalia msg panel-toggle …`), volume/brightness scroll goes through Noctalia so its OSD shows. Spacing grid: icon→text 7px, 8px inside a group, 16px between groups.

Detailed notes (Russian): `themes/README.md`.
