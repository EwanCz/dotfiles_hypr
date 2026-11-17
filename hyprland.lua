-- get the hyprland root config. fallback to .config if missing
local hyprRoot

if os.getenv("HYPRLAND_ROOT") then
    hyprRoot = os.getenv("HYPRLAND_ROOT")
else
    hyprRoot = os.getenv("HOME") .. "/.config/hypr"
end

-- Use global HyprRoot to extrappolate modules
local modules = hyprRoot .. "/modules"

-- get the lua files in modules
local files = io.popen('find -L "' .. modules .. '" -name "*.lua" -type f | sort')
if not files then
    return
end

for path in files:lines() do
    local ok, error = pcall(dofile, path)
    -- add notification if fail
    if not ok then
        hl.notification.create({
            text = "autoload: " .. path .. "\n" .. tostring(error),
            timeout = 8000,
            icon = "warning",
        })
    end
end

files:close()
