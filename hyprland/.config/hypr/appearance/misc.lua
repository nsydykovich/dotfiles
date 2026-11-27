hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        render_unfocused_fps = 60,
        vrr = 2  -- FreeSync только для полноэкранных окон
    },
})
-- unscale XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})
