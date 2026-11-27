-- 10 постоянных рабочих столов: живут даже пустыми, поэтому панель noctalia всегда показывает 10 кружков.
for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
