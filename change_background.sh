WALL_DIR="$HOME/Pictures/backgrounds/"
STATE_FILE="$HOME/.cache/hyprpaper.index"
MONITOR=" " # Replace with your actual monitor name from `hyprctl monitors`

# Get list of wallpapers
WALLS=("$WALL_DIR"/*)
NUM=${#WALLS[@]}

# Read current index
if [[ -f "$STATE_FILE" ]]; then
	IDX=$(<"$STATE_FILE")
else
	IDX=0
fi

# Ensure index is within range
IDX=$((IDX % NUM))

# Get current wallpaper
WALL="${WALLS[$IDX]}"

ln -sf "$WALL" "$HOME/Pictures/background"

pkill -SIGUSR2 hyprlock

# Preload and set wallpaper
hyprctl hyprpaper reload
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper "$MONITOR,$WALL"

# Update index
echo $(((IDX + 1) % NUM)) >"$STATE_FILE"
