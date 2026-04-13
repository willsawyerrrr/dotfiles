local colours = require("colours")
local properties = require("properties")
local utils = require("utils")

local willow = sbar.add(
	"item",
	"willow",
	utils.merge_tables(properties.for_right_pill(colours.purple), {
		drawing = "off",
		icon = "󰍬",
		label = "Dictating",
	})
)
local willow_start_event = sbar.add("event", "willow_start")
local willow_stop_event = sbar.add("event", "willow_stop")

willow:subscribe({ willow_start_event.name, willow_stop_event.name }, function(env)
	if env.SENDER == willow_start_event.name then
		willow:set({ drawing = "on" })
	elseif env.SENDER == willow_stop_event.name then
		willow:set({ drawing = "off" })
	end
end)
