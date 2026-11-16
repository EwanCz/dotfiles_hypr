-- mine
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = "1",
    transform = 0,
})

-- usb-c
hl.monitor({
    output = "DP-2",
    mode = "preferred",
    position = "auto-right",
    scale = "1",
    transform = 0,
})

-- other (HDMI)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto-up",
    scale = "1",
    transform = 0,
})
