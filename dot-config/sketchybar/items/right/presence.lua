local colours = require("colours")
local properties = require("properties")

local icons = {
	on = "󰅶",
	off = "󰾪",
}

local jiggle = "while :; do cliclick m:+1,+0 m:-1,+0; sleep 60; done"

local presence = sbar.add("item", "presence", properties.for_right_pill(colours.yellow))

local function update_presence()
	sbar.exec("pgrep -x caffeinate && pgrep -f 'cliclick m:'", function(_, exit_code)
		local active = exit_code == 0

		presence:set({
			icon = {
				string = active and icons.on or icons.off,
				color = active and colours.yellow or colours.comment,
			},
			label = active and "On" or "Off",
		})
	end)
end

local function toggle_presence()
	sbar.exec("pgrep -x caffeinate", function(_, exit_code)
		if exit_code == 0 then
			sbar.exec("pkill -x caffeinate; pkill -f 'cliclick m:'", update_presence)
		else
			sbar.exec(
				'nohup caffeinate -d >/dev/null 2>&1 & disown; nohup sh -c "' .. jiggle .. '" >/dev/null 2>&1 & disown',
				update_presence
			)
		end
	end)
end

presence:subscribe("mouse.clicked", toggle_presence)
presence:subscribe({ "routine", "system_woke" }, update_presence)

update_presence()
