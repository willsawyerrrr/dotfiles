local colours = require("colours")
local properties = require("properties")
local utils = require("utils")

local icons = {
	charging = {
		_0 = "󰢟",
		_10 = "󰢜",
		_20 = "󰂆",
		_30 = "󰂇",
		_40 = "󰂈",
		_50 = "󰢝",
		_60 = "󰂉",
		_70 = "󰢞",
		_80 = "󰂊",
		_90 = "󰂋",
		_100 = "󰂅",
	},
	_0 = "󰂎",
	_10 = "󰁺",
	_20 = "󰁻",
	_30 = "󰁼",
	_40 = "󰁽",
	_50 = "󰁾",
	_60 = "󰁿",
	_70 = "󰂀",
	_80 = "󰂁",
	_90 = "󰂂",
	_100 = "󰁹",
}

local battery = sbar.add(
	"item",
	"battery",
	utils.merge_tables(properties.for_right_pill(colours.green), {
		update_freq = 120,
	})
)

local update_battery = utils.use_battery_details(function(charging, charge)
	local label = ""
	if charge then
		label = charge .. "%"
	end

	local battery_icons = icons
	if charging then
		battery_icons = battery_icons.charging
	end

	local icon_key = "_" .. math.floor(charge / 10) * 10
	local icon = battery_icons[icon_key]

	battery:set({
		icon = icon,
		label = label,
	})
end)

battery:subscribe({ "routine", "system_woke", "power_source_change" }, update_battery)
