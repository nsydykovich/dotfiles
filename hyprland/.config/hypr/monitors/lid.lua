-- Крышка: закрыл -> встроенный экран гаснет (DPMS off), открыл -> включается.
-- Сон/Wi-Fi не трогаем: logind настроен на ignore (/etc/systemd/logind.conf.d/10-lid-ignore.conf).
-- Если подключён внешний монитор, ничего не делаем: eDP-1 и так выключен в hotplug.lua.
-- DPMS ставим через таймер: wiki не рекомендует дёргать dpms прямо из бинда.

local internal_monitor = "eDP-1"

local function has_external()
    for _, m in ipairs(hl.get_monitors() or {}) do
        if m.name and m.name ~= internal_monitor and m.name ~= "FALLBACK" then return true end
    end
    return false
end

local function set_internal_dpms(action)
    if has_external() then return end
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = action, monitor = internal_monitor }))
    end, { timeout = 500, type = "oneshot" })
end

hl.bind("switch:on:Lid Switch",  function() set_internal_dpms("disable") end, { locked = true })
hl.bind("switch:off:Lid Switch", function() set_internal_dpms("enable") end,  { locked = true })
