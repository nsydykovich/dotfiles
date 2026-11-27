-- Потребление APU (CPU + встроенная GPU) в ваттах.
-- Источник: hwmon "amdgpu" -> power1_input (PPT, микроватты). Номер hwmon ищем при старте — он может меняться между загрузками.
-- Если датчика нет — показываем общее потребление от батареи (power_now).

local sensor = nil
local battery = "/sys/class/power_supply/BAT1/power_now"

local function trim(s) return s and (string.gsub(s, "%s+$", "")) or nil end

local function findSensor()
  for i = 0, 20 do
    local base = "/sys/class/hwmon/hwmon" .. i
    if trim(noctalia.readFile(base .. "/name")) == "amdgpu" and noctalia.readFile(base .. "/power1_input") then
      return base .. "/power1_input"
    end
  end
  return nil
end

local function watts(path)
  local raw = trim(noctalia.readFile(path))
  local uw = raw and tonumber(raw)
  return uw and uw / 1e6 or nil
end

function update()
  noctalia.setUpdateInterval(2000)
  if not sensor then sensor = findSensor() end

  local pkg = sensor and watts(sensor)
  local sys = watts(battery)
  barWidget.setGlyph("bolt")
  if pkg then
    barWidget.setText(string.format("%.1f W", pkg))
    local tip = string.format("CPU + GPU package power (PPT): %.1f W", pkg)
    if sys and sys > 0 then tip = tip .. string.format("\nWhole system (battery): %.1f W", sys) end
    barWidget.setTooltip(tip)
  elseif sys then
    barWidget.setText(string.format("%.1f W", sys))
    barWidget.setTooltip("Whole system power draw (battery)")
  else
    barWidget.setText("— W")
    barWidget.setTooltip("No power sensor found")
  end
end
