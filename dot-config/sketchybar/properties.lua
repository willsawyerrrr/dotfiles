local colours = require("colours")
local utils = require("utils")

local M = {}

M.dummy_left = {
	background = {
		border_color = 0xffff0000,
		border_width = 10,
		color = 0xff00ff00,
		padding_left = 0,
		padding_right = 0,
	},
	icon = {
		padding_left = 0,
		padding_right = 0,
	},
	label = {
		color = colours.selection,
		padding_left = 0,
		padding_right = 0,
	},
	width = 7,
}

M.dummy_right = utils.merge_tables(M.dummy_left, { position = "right" })

function M.for_left_pill(colour)
	return {
		background = {
			border_color = colour,
			color = colours.selection,
			corner_radius = 20,
		},
		icon = {
			background = {
				drawing = "on",
				image = {
					border_color = colour,
					-- border_width = 1, -- A border looks okay-ish
					corner_radius = 7,
					drawing = "on",
					padding_left = 12,
					padding_right = 4,
					scale = 0.8,
				},
			},
			color = colour,
			padding_left = 12,
			padding_right = 4,
		},
		label = {
			color = colours.foreground,
			padding_right = 12,
		},
	}
end

function M.for_right_pill(colour)
	return utils.merge_tables(M.for_left_pill(colour), { position = "right" })
end

return M
