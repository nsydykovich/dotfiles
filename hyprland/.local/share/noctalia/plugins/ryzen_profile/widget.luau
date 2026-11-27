-- Кнопка пресетов ryzen-profile.
-- ЛКМ — следующий пресет, ПКМ — предыдущий. Текущий пресет читается из /etc/ryzenadj.conf.

local CONF = "/etc/ryzenadj.conf"
local CMD = "sudo -n /usr/local/bin/ryzen-profile "

local PROFILES = {
  eco         = { glyph = "leaf",   text = "ECO",  tip = "ECO — 8 Вт, до 1800 МГц" },
  balanced    = { glyph = "scale",  text = "BAL",  tip = "BALANCED — 12 Вт, до 2500 МГц" },
  performance = { glyph = "rocket", text = "PERF", tip = "PERFORMANCE — 15 Вт, до 3200 МГц" },
}

local shown = nil

local function readProfile()
  local data = noctalia.readFile(CONF)
  if not data then return nil end
  return string.match(data, "\nPROFILE=(%a+)") or string.match(data, "^PROFILE=(%a+)")
end

local function render(name)
  local p = PROFILES[name]
  if not p then
    barWidget.setGlyph("cpu")
    barWidget.setText("?")
    barWidget.setTooltip("ryzen-profile: не удалось прочитать " .. CONF)
    return
  end
  barWidget.setGlyph(p.glyph)
  barWidget.setText(p.text)
  barWidget.setTooltip(p.tip .. "\nЛКМ — следующий, ПКМ — предыдущий")
end

local function refresh()
  local name = readProfile()
  if name ~= shown then
    shown = name
    render(name)
  end
end

local function switch(dir)
  noctalia.runAsync(CMD .. dir, function(result)
    if result.exitCode ~= 0 then
      noctalia.notify("Ryzen Profile", "Не удалось переключить: " .. (result.stderr or ""))
    end
    refresh()
    local p = PROFILES[shown or ""]
    if p then noctalia.notify("Ryzen Profile", p.tip) end
  end)
end

function update()
  noctalia.setUpdateInterval(2000)
  refresh()
end

function onClick()
  switch("next")
end

function onRightClick()
  switch("prev")
end
