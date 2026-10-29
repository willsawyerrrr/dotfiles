package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

---@diagnostic disable-next-line: lowercase-global
sbar = require("sketchybar")

local colours = require("colours")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()

require("bar")
sbar.default({
	background = {
		border_width = 2,
		height = 33,
	},
	icon = {
		background = {
			image = {},
		},
		font = {
			family = "JetBrainsMonoNL Nerd Font",
			size = 20.0,
			style = "Bold",
		},
	},
	label = {
		font = {
			family = "JetBrainsMonoNL Nerd Font",
			size = 14.5,
			style = "Bold",
		},
		padding_left = 4,
		padding_right = 4,
	},
	padding_left = 5,
	padding_right = 5,
	popup = {
		background = {
			drawing = "on",
			border_width = 2,
			border_color = colours.foreground,
			corner_radius = 5,
		},
		blur_radius = 10,
		height = 30,
		y_offset = -10,
	},
})
require("items")
sbar.hotload(true)

sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
