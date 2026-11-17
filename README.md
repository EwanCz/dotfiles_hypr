# dotfiles_hypr

Personal Hyprland setup.
It uses Hyprland's native Lua configuration API (the `hl` module), so every file here
is a `.lua` file calling functions like `hl.config()`, `hl.bind()`, and
`hl.monitor()`. You need a Hyprland build that supports the Lua config backend
for any of this to load.

## Packaging

The repo also ships a `flake.nix` that wraps `hyprland`, `hyprlock`,
`hypridle`, and `hyprpaper` with these config files baked in as their default
`--config` flag, plus the runtime tools they call out to (`hyprshot`,
`brightnessctl`, `playerctl`, `hyprpolkitagent`). If you're on Nix, `nix build`
or `nix run` gets you a working session. If you're not, the flake is
irrelevant to you — just drop `hyprland.lua`, `modules/`, and `scripts/` into
`~/.config/hypr/` and point `hyprlock`/`hypridle`/`hyprpaper` at their
respective `.conf` files yourself.

## Hyprland configuration

`hyprland.lua` is just a bootstrapper: it resolves the config root
(`HYPRLAND_ROOT` env var, falling back to `~/.config/hypr`), then `dofile`s
every `*.lua` file under `modules/` in alphabetical order inside a `pcall` —
so a broken module surfaces as a desktop notification instead of a crashed
reload, and load order is controlled purely by filename.

The modules themselves:

- **`base.lua`** — environment variables, startup execs (`hyprpaper`,
  `hypridle`, `barust`, the polkit agent), keyboard/touchpad/device input
  settings, and a couple of window rules working around a maximize/drag bug.
- **`look.lua`** — general look and feel: gaps, borders, rounding, shadow,
  blur, layout, plus animations (disabled globally, re-enabled only for the
  special-workspace slide) and the 3-finger workspace-swipe gesture.
- **`monitor.lua`** — static per-output layout for this machine's three
  known monitors (laptop panel, USB-C dock, HDMI catch-all).
- **`binds.lua`** — every keyboard/mouse binding (see the
  [keybindings table](#keybindings)), built with `hl.dsp.*` dispatcher
  helpers and a loop for the ten workspace binds.
- **`special_workspaces.lua`** — a small scratchpad pattern that pins
  Spotify/Discord/Zen to their own special workspaces, each auto-launched and
  toggled with its own bind.

## Lock, idle, and wallpaper daemons

These are plain Hyprland-ecosystem config files (not Lua), consumed by their
respective daemons:

- **`hyprlock.conf`** — background blur/contrast/vibrancy tuning, a
  password input field, and three clock/date/user labels. The hour and minute
  labels poll `date` every 1–1.5s rather than using a built-in clock widget.
- **`hypridle.conf`** — a staged idle timeline: dim the backlight at 2.5min,
  lock the session at 5min, turn the display off at 5.5min, suspend at
  15min. Also locks before suspend and restores DPMS after resume so you don't
  need to press a key twice to wake the display.
- **`hyprpaper.conf`** — a single wallpaper entry pointing at
  `~/Pictures/background`, which is a symlink maintained by
  `change_background.sh` (see below), not a real file.

## Scripts

### `scripts/change_background.sh`

Cycles through wallpapers in `~/Pictures/backgrounds/`:

`MONITOR=""` is passed through to `hyprctl hyprpaper wallpaper` as-is; an
empty value applies the wallpaper to all monitors. Set it to a specific output
name if you want this script to only touch one screen.

Bound to `SUPER+SHIFT+B`.

### `scripts/toggle_mirror.sh`

Toggles mirroring of every connected external monitor onto the laptop screen,
without touching `monitor.lua`:

This is a runtime-only change via `hyprctl eval` — it does not persist, and a
`hyprctl reload` (or Hyprland restart) reverts to whatever `monitor.lua`
says.

Bound to `SUPER+SHIFT+M`.

## Keybindings

All with `mainMod = SUPER` unless noted.

| Bind | Action |
|---|---|
| `SUPER+Q` | Launch `kitty` |
| `SUPER+Z` | Toggle fullscreen |
| `SUPER+W` | Close focused window |
| `SUPER+SHIFT+P` | Exit Hyprland |
| `SUPER+P` | Lock screen (`hyprlock`) |
| `SUPER+SHIFT+B` | Cycle wallpaper (`change_background.sh`) |
| `SUPER+SHIFT+M` | Toggle monitor mirroring (`toggle_mirror.sh`) |
| `SUPER+SHIFT+R` | Restart `barust` status bar |
| `SUPER+SPACE` | Toggle `barust` launcher |
| `SUPER+V` | Toggle floating on focused window |
| `Print` | Window screenshot (`hyprshot -m window`) |
| `SUPER+Print` | Region screenshot (`hyprshot -m region`) |
| `SUPER+H/L/K/J` | Move focus left/right/up/down |
| `SUPER+F` | Swap with master (layout) |
| `SUPER+[0-9]` | Switch to workspace 1–10 |
| `SUPER+SHIFT+[0-9]` | Move focused window to workspace 1–10 |
| `SUPER+TAB` | Toggle special workspace `magic` |
| `SUPER+SHIFT+TAB` | Move focused window to special workspace `magic` |
| `SUPER+M` | Toggle special workspace `spotify` |
| `SUPER+D` | Toggle special workspace `discord` |
| `SUPER+S` | Toggle special workspace `zen` |
| `SUPER+scroll down/up` | Next/previous workspace |
| `SUPER+LMB` drag | Move window |
| `SUPER+RMB` drag | Resize window |
| `XF86AudioRaiseVolume` / `LowerVolume` | Volume +/- 5% |
| `XF86AudioMute` / `AudioMicMute` | Toggle speaker / mic mute |
| `XF86MonBrightnessUp` / `Down` | Brightness +/- 5% |
| `XF86AudioNext` / `Prev` / `Play` / `Pause` | Media control (`playerctl`) |

## Customizing for your own machine

Things specific to the my pc that you'll likely want to
change:

- **`modules/monitor.lua`** — output names (`eDP-1`, `DP-2`) and positions
  are specific to my pc + dock. Run `hyprctl monitors` to get your own
  output names.
- **`scripts/toggle_mirror.sh`** — `MAIN="eDP-1"` needs to match your
  internal panel's name, and the `HDMI-*` vs. default position logic assumes
  this exact two-external-monitor setup.
- **`scripts/change_background.sh`** — expects wallpapers in
  `~/Pictures/backgrounmds/` (plural); create that directory and drop images
  in before binding/using it.
