# dotfiles

My dotfiles, one [GNU Stow](https://www.gnu.org/software/stow/) package per setup:

| Package | Setup |
|---|---|
| [`hyprland/`](hyprland/) | **current** — Hyprland (Lua config) · waybar · Noctalia · AncientAliens palette |
| `awesome/` | AwesomeWM, nordic_dark (2024) |
| `bspwm/` | bspwm + polybar (2024) |

```sh
git clone --recurse-submodules https://github.com/nsydykovich/dotfiles ~/dotfiles
cd ~/dotfiles && stow hyprland
```
