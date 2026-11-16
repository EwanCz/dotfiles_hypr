hl.env("XCURSOR_SIZE", 24)
hl.env("XCURSOR_THEME", "Vanilla-DMZ")
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("HYPRSHOT_DIR", "/home/zethec/Pictures/Screenshot/")

require("hyprland_conf.binds")
require("hyprland_conf.monitor")
require("hyprland_conf.special_workspaces")
require("hyprland_conf.look")

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("barust")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Suppress maximize events for all windows
hl.window_rule({
    name = "suppress-maximize",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drag",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        focus = true,
    },
    suppress_event = "maximize",
})
