-- Launch the Willow watcher in the background, killing any previous instance first.
local home = os.getenv("HOME")
os.execute("pkill -f willow-watcher.sh 2>/dev/null; " .. home .. "/.config/sketchybar/scripts/willow-watcher.sh &")
