-- Привязка тачскрина и стилуса к встроенному монитору.
-- Hyprland не ремаппит координаты сенсора при повороте eDP-1 сам,
-- поэтому transform для этих устройств выставляется отдельно
-- в scripts/monitor-rotate.sh синхронно с transform монитора.

hl.device({
    name   = "elan2514:00-04f3:2b11",
    output = "eDP-1",
})

hl.device({
    name   = "elan2514:00-04f3:2b11-stylus",
    output = "eDP-1",
})
