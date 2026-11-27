hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- -- Cycle to the next window in Monocle layout
-- hl.bind(mainMod .. "+ Tab", function()
--     hl.dispatch(hl.dsp.layout("cyclenext"))
-- end)
--
-- -- Cycle to the previous window in Monocle layout
-- hl.bind(mainMod .. "+ SHIFT + Tab", function()
--     hl.dispatch(hl.dsp.layout("cycleprev"))
-- end)
