local colours = require("colours")
local properties = require("properties")
local utils = require("utils")

local aerospace_status_changed_event = sbar.add("event", "aerospace_status_change")

local aerospace_status = sbar.add(
	"item",
	"aerospace status",
	utils.merge_tables(properties.for_right_pill(colours.pink), {
		drawing = "off",
		icon = {
			background = {
				image = "app.AeroSpace",
			},
		},
	})
)
aerospace_status:subscribe(aerospace_status_changed_event.name, function(env)
	local mode = env.MODE ---@type string

	local title_cased_mode = mode:sub(1, 1):upper() .. mode:sub(2, -1)

	aerospace_status:set({
		drawing = mode == "main" and "off" or "on",
		label = title_cased_mode .. " mode",
	})
end)
