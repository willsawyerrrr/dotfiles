local colours = require("colours")

local unlocked = {
	position = "top",
	height = 50,
	color = colours.transparent,
	y_offset = 0,
	margin = 0,
}

sbar.bar(unlocked)

local lock_event = sbar.add("event", "lock", "com.apple.screenIsLocked")
local unlock_event = sbar.add("event", "unlock", "com.apple.screenIsUnlocked")

local animator = sbar.add("item", "animator", { drawing = "off" })
animator:subscribe({ lock_event.name, unlock_event.name }, function(env)
	local properties
	if env.SENDER == lock_event.name then
		properties = {
			y_offset = -20,
			margin = -30,
		}
	elseif env.SENDER == unlock_event.name then
		properties = unlocked
	end

	sbar.animate("sin", 15, function()
		sbar.bar(properties)
	end)
end)
