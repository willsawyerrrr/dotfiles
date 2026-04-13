local colours = require("colours")
local properties = require("properties")
local utils = require("utils")

local datetime_item = sbar.add(
	"item",
	"datetime",
	utils.merge_tables(properties.for_right_pill(colours.cyan), {
		icon = {
			string = "󰃶",
			y_offset = 1,
		},
		update_freq = 1,
	})
)

local seconds_override = false

local update_datetime = utils.use_battery_details(function(charging, _)
	local datetime_format = "%d %B %I:%M"

	if charging or seconds_override then
		datetime_format = datetime_format .. ":%S"
	end

	datetime_format = datetime_format .. " %p"

	---@diagnostic disable-next-line: assign-type-mismatch
	local datetime = os.date(datetime_format) ---@type string
	if datetime:sub(1, 1) == "0" then
		datetime = datetime:sub(2)
	end

	datetime_item:set({ label = datetime })
end)
datetime_item:subscribe("routine", update_datetime)
update_datetime()

local function update_frequency(env)
	local power_source = env.INFO

	local frequency
	if power_source == "AC" then
		-- Showing seconds, so check every second
		frequency = 1
	elseif power_source == "BATTERY" then
		-- Showing minutes, so only check every 10 seconds
		frequency = 10
	end

	datetime_item:set({ update_freq = frequency })
end
datetime_item:subscribe("power_source_change", update_frequency)

local function temporarily_show_seconds(_)
	if datetime_item:query().update_freq == 1 then
		return
	end

	seconds_override = true
	update_datetime()
	datetime_item:set({ update_freq = 1 })

	sbar.exec("sleep 5", function()
		seconds_override = false
		update_datetime()
		datetime_item:set({ update_freq = 10 })
	end)
end
datetime_item:subscribe({ "mouse.clicked" }, temporarily_show_seconds)
