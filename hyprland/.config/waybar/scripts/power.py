#!/usr/bin/env python3
"""Мощность APU для waybar: PPT FAST из pm_table SMU (то, что ограничивает ryzenadj --fast-limit).
pm_table (ryzen_smu) читается без root. Раскладка для Lucienne/Renoir (PM table 0x37000x), float32:
  [0] STAPM limit  [1] STAPM value  [2] PPT FAST limit  [3] PPT FAST value  [4] PPT SLOW limit  [5] PPT SLOW value
Нет таблицы -> hwmon amdgpu power1_input (мгновенное значение, с пиками)."""
import glob, json, struct

def pm():
    try:
        d = open("/sys/kernel/ryzen_smu_drv/pm_table", "rb").read(24)
        return struct.unpack("<6f", d)
    except Exception:
        return None

t = pm()
if t:
    stapm_l, stapm_v, fast_l, fast_v, slow_l, slow_v = t
    w = fast_v
    tip = (f"APU power (CPU + GPU), PPT fast: {fast_v:.1f} / {fast_l:.0f} W\n"
           f"PPT slow: {slow_v:.1f} / {slow_l:.0f} W\n"
           f"STAPM: {stapm_v:.1f} / {stapm_l:.1f} W")
    cls = "high" if fast_v >= fast_l * 0.95 else "normal"
else:
    w, tip, cls = 0.0, "No power sensor", "normal"
    for h in glob.glob("/sys/class/hwmon/hwmon*"):
        try:
            if open(h + "/name").read().strip() == "amdgpu":
                w = int(open(h + "/power1_input").read()) / 1e6
                tip = "amdgpu socket power (instant)"
                break
        except Exception:
            pass
print(json.dumps({"text": f"{w:.1f} W", "tooltip": tip, "class": cls}))
