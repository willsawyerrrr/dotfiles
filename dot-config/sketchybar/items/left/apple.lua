local colours = require("colours")
local popup = require("popup")
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
apple:subscribe({ "mouse.clicked" }, popup.toggle_popup(apple))

sbar.add("bracket", "bracket.apple", { apple.name }, {
	background = {
		border_color = colours.foreground,
		color = colours.transparent,
		corner_radius = 11,
		height = 29,
	},
})

sbar.add("item", "dummy.post_apple", properties.dummy_left)

local apple_popup_items = {
	sbar.add("item", "apple.sleep", {
		position = "popup." .. apple.name,
		label = "Sleep",
		click_script = "pmset displaysleepnow",
	}),
	sbar.add("item", "apple.lock", {
		position = "popup." .. apple.name,
		label = "Lock",
		click_script = 'osascript -e \'tell application "System Events" to keystroke "q" using {control down, command down}\'',
	}),
	sbar.add("item", "apple.logout", {
		position = "popup." .. apple.name,
		label = "Logout",
		click_script = 'osascript -e \'tell application "System Events" to keystroke "Q" using {option down, command down}\'',
	}),
}
for _, apple_popup_item in ipairs(apple_popup_items) do
	apple_popup_item:subscribe({ "mouse.clicked" }, popup.toggle_popup(apple))
end
