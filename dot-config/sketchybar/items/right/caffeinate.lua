local colours = require("colours")
local properties = require("properties")

local icons = {
	on = "󰅶",
	off = "󰾪",
}

local caffeinate = sbar.add("item", "caffeinate", properties.for_right_pill(colours.yellow))

local function update_caffeinate()
	sbar.exec("pgrep -x caffeinate", function(_, exit_code)
		local active = exit_code == 0

		caffeinate:set({
			icon = {
				string = active and icons.on or icons.off,
				color = active and colours.yellow or colours.comment,
			},
			label = active and "On" or "Off",
		})
	end)
end

local function toggle_caffeinate()
	sbar.exec("pgrep -x caffeinate", function(_, exit_code)
		if exit_code == 0 then
			sbar.exec("pkill -x caffeinate", update_caffeinate)
		else
			sbar.exec("nohup caffeinate -d >/dev/null 2>&1 & disown", update_caffeinate)
		end
	end)
end

caffeinate:subscribe("mouse.clicked", toggle_caffeinate)
caffeinate:subscribe({ "routine", "system_woke" }, update_caffeinate)

update_caffeinate()
