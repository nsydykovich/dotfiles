hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

--hl.window_rule({
--    name           = "suppress-slowing-down",
--    match          = { class = ".*" },
--    render_unfocused = true,
--})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture|Картинка в картинке)$" },
    float = true,
    pin   = true,
    -- 25% ширины монитора, 16:9; правый нижний угол с отступом 20px
    size  = "monitor_w*0.25 monitor_w*0.140625",
    move  = "monitor_w-window_w-8 monitor_h-window_h-8",
    keep_aspect_ratio = true, -- ресайз мышью только с сохранением пропорций
})

hl.window_rule({
    name = "waydroid-floating-apps",
    match = {
        class = "^[Ww]aydroid",
    },
    float = true,
    center = true,
    size = {460, 940},
})

hl.window_rule({
    name = "waydroid-all-apps-vertical",
    match = {
        -- Ловит главный интерфейс (Waydroid) и все приложения (waydroid.com.whatsapp и т.д.)
        class = ".*[Ww]aydroid.*",
    },
    float = true,
    center = true,
    size = {460, 940},
})

hl.window_rule({
    name           = "minecraft-allow-background",
    -- 26.x на Wayland: class = com.mojang.minecraft; старые версии/XWayland: Minecraft*
    match          = { class = "^(com\\.mojang\\.minecraft|Minecraft.*)$" },
    render_unfocused = true,
})

-- 1.21.x и старше на Wayland не задают app_id (class пустой) — ловим по заголовку
hl.window_rule({
    name           = "minecraft-allow-background-title",
    match          = { title = "^Minecraft\\*? [0-9].*$" },
    render_unfocused = true,
})

-- hl.window_rule({
--     name           = "all-float",
--     match          = { class = ".*" },
--     float = true,
-- })
