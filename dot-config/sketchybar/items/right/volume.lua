local colours = require("colours")
local properties = require("properties")

local icons = {
	high = "󰕾",
	medium = "󰖀",
	low = "󰕿",
	muted = "󰝟",
}

local volume_item = sbar.add("item", "volume", properties.for_right_pill(colours.purple))
volume_item:subscribe("volume_change", function(env)
	local volume = tonumber(env.INFO)

	local icon
	if volume > 60 then
		icon = icons.high
	elseif volume > 30 then
		icon = icons.medium
	elseif volume > 0 then
		icon = icons.low
	elseif volume == 0 then
		icon = icons.muted
	end

	volume_item:set({
		icon = icon,
		label = volume .. "%",
	})
end)
