--!nonstrict
-- Плитка пресетов ryzen-profile в центре управления.
-- ЛКМ — следующий пресет, ПКМ — предыдущий. Подсвечена, когда включён PERFORMANCE.

local CONF = "/etc/ryzenadj.conf"
local CMD = "sudo -n /usr/local/bin/ryzen-profile "

local PROFILES = {
  eco         = { glyph = "leaf",   label = "Eco · 8W" },
  balanced    = { glyph = "scale",  label = "Balanced · 12W" },
  performance = { glyph = "rocket", label = "Perf · 15W" },
}

local function readProfile()
  local data = noctalia.readFile(CONF)
  if not data then return nil end
  return string.match(data, "\nPROFILE=(%a+)") or string.match(data, "^PROFILE=(%a+)")
end

local function render()
  local name = readProfile()
  local p = PROFILES[name or ""]
  if p then
    shortcut.setLabel(p.label)
    shortcut.setIcon(p.glyph)
  else
    shortcut.setLabel("CPU ?")
    shortcut.setIcon("cpu")
  end
  shortcut.setActive(name == "performance")
  shortcut.setEnabled(true)
end

local function switch(dir)
  noctalia.runAsync(CMD .. dir, function(result)
    if result.exitCode ~= 0 then
      noctalia.notify("Ryzen Profile", "Не удалось переключить: " .. (result.stderr or ""))
    end
    render()
  end)
end

render()

-- на случай, если плитки тоже получают update()
function update()
  noctalia.setUpdateInterval(2000)
  render()
end

function onClick() switch("next") end
function onRightClick() switch("prev") end
function onIpc(event, payload) render() end
