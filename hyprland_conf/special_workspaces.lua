local mainMod = "SUPER"

hl.config({
    binds = {
        hide_special_on_workspace_change = true,
    },
})

local workspaces = {
    { name = "spotify", class = "Spotify", bind = "M" },
    { name = "discord", class = "discord", bind = "D" },
    { name = "zen", class = "zen", bind = "S" },
}

hl.workspace_rule({ workspace = "s[true]", gaps_out = { top = 90, bottom = 0, left = 40, right = 40 } })

for _, workspace in ipairs(workspaces) do
    hl.workspace_rule({ workspace = "special:" .. workspace.name, on_created_empty = workspace.name })
    hl.window_rule({
        name = workspace.name .. "_workspace",
        enabled = true,
        match = { class = "^(" .. workspace.class .. ")$", workspace = "special:" .. workspace.name },
    })
    hl.bind(mainMod .. " + " .. workspace.bind, hl.dsp.workspace.toggle_special(workspace.name))
end
