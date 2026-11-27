hl.config({ animations = { enabled = true } })

-- Material Design 3 кривые (ml4w/Google)
hl.curve("md3_decel",  { type = "bezier", points = { { 0.05, 0.7  }, { 0.1, 1    } } })
hl.curve("md3_accel",  { type = "bezier", points = { { 0.3,  0    }, { 0.8, 0.15 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1,  1    }, { 0,   1    } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.38, 0.04 }, { 1,   0.07 } } })
hl.curve("easeOutExpo",{ type = "bezier", points = { { 0.16, 1    }, { 0.3, 1    } } })

-- Окна
hl.animation({ leaf = "windows",    enabled = true, speed = 3,   bezier = "md3_decel",  style = "popin 60%" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3,   bezier = "md3_decel",  style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3,   bezier = "md3_accel",  style = "popin 60%" })

-- Fade
hl.animation({ leaf = "fade",    enabled = true, speed = 3, bezier = "md3_decel" })
hl.animation({ leaf = "fadeIn",  enabled = true, speed = 3, bezier = "md3_decel" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "md3_accel" })

-- Бордер
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })

-- Слои (панели, меню) — slide с decel/accel
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.6, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,   bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 4.5, bezier = "menu_accel" })

-- Workspaces
hl.animation({ leaf = "workspaces",   enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "workspacesOut",enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })
