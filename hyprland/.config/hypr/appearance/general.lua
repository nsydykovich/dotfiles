hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 2,
        col              = {
            active_border   = { colors = { "rgba(aad5f0ff)", "rgba(6fa6ccff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(182532ff)", "rgba(2d485bff)" }, angle = 45 },
        },
        resize_on_border = false,
        allow_tearing    = true,  -- tearing только по запросу приложения (wp_tearing_control)
        layout           = "dwindle",
    },
})
