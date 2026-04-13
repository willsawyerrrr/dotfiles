local colours = require("colours")
local properties = require("properties")

sbar.add("item", "dummy.pre_apple", properties.dummy_left)

local apple = sbar.add("item", "apple", {
	icon = {
		string = "",
		padding_left = 4,
		padding_right = 5,
		y_offset = -1,
	},
	label = {
		drawing = "off",
	},
	padding_left = 3,
	padding_right = 3,
	position = "left",
})

sbar.add("bracket", "bracket.apple", { apple.name }, {
	background = {
		border_color = colours.foreground,
		color = colours.transparent,
		corner_radius = 11,
		height = 29,
	},
})

sbar.add("item", "dummy.post_apple", properties.dummy_left)
