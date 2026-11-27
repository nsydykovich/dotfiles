-- Размытие под островками waybar. Прозрачные промежутки (alpha ≈ 0) не размываются.
hl.layer_rule({
    name         = "waybar-blur",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.2,
})
