hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 6,

        border_size = 3,

        col = {
            active_border = { colors = { "rgba(e67000cc)", "rgba(e81381cc)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        allow_tearing = false,

        layout = "master",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 5,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = false,
            size = 3,
            passes = 1,

            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "slave",
    },

    misc = {
        force_default_wallpaper = 1, -- Set to 0 or 1 to disable the anime mascot wallpapers

        disable_hyprland_logo = true, -- If true disables the random hyprland logo / animslave background.
    },
})

-- Keep only the bezier used by your specialWorkspace animation
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })

-- Disable all animations by default using the 'global' node
hl.animation({ leaf = "global", enabled = false })

-- Explicitly enable and configure the specialWorkspace animation
-- This overrides the 'global, 0' setting for this specific item
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOutQuint", style = "slidevert" })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
