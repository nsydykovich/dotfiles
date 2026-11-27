-- Точка входа Hyprland (Lua, 0.55+). Модули лежат рядом: appearance/, input/, keybindings/, monitors/, rules/.
local config_dir = os.getenv("HOME") .. "/.config/hypr"
package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

require("monitors")
require("autostart")
require("env")
require("appearance")
require("input")
require("keybindings")
require("rules")
