-- Внешний монитор подключён -> встроенный (eDP-1) выключается.
-- Внешний отключён -> встроенный включается обратно.
-- Решение принимается при каждой загрузке конфига, а на hotplug
-- просто делаем reload, так что работает и при старте, и при ручном reload.

local internal_monitor = "eDP-1"

local function is_external(name)
    return name and name ~= internal_monitor and name ~= "FALLBACK"
end

local function has_external()
    for _, m in ipairs(hl.get_monitors() or {}) do
        if is_external(m.name) then return true end
    end
    return false
end

local function apply()
    if has_external() then
        hl.monitor({ output = internal_monitor, disabled = true })
        hl.exec_cmd("echo 'Xft.dpi: 96' | xrdb -merge")
    else
        hl.exec_cmd("echo 'Xft.dpi: 120' | xrdb -merge")
    end
end

local function on_hotplug(monitor)
    if not monitor or not is_external(monitor.name) then return end
    hl.timer(function()
        hl.exec_cmd("hyprctl reload")
    end, { timeout = 700, type = "oneshot" })
end

hl.on("monitor.added", on_hotplug)
hl.on("monitor.removed", on_hotplug)

-- При старте Hyprland мониторы могут появиться уже после загрузки конфига
hl.on("hyprland.start", function()
    hl.timer(function()
        if has_external() then hl.exec_cmd("hyprctl reload") end
    end, { timeout = 1000, type = "oneshot" })
end)

apply()
