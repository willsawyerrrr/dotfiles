local aerospace_utils = require("items.left.aerospace.utils")
local colours = require("colours")
local properties = require("properties")

local workspace_items = {}

local function properties_for_workspace(workspace_id, focused)
	local drawing = focused and "on" or "off"

	local workspace_properties = {
		align = "center",
		background = {
			color = colours.pink,
			drawing = drawing,
			height = 31,
		},
		label = {
			string = workspace_id,
			padding_left = 10,
			padding_right = 11,
		},
		padding_left = 0,
		padding_right = 0,
		click_script = "aerospace workspace " .. workspace_id,
	}

	-- TODO: Show an inactive status to differentiate between "no windows" and "no active windows"
	--
	-- sbar.exec("aerospace list-windows --workspace " .. workspace_id .. " 2>/dev/null | wc -l", function(window_count)
	-- 	if window_count == 0 then
	-- 		workspace:set({ background = { drawing = "off" } })
	-- 	else
	-- 		workspace:set({ background = { drawing = "on" } })
	-- 	end
	-- end)

	return workspace_properties
end

local aerospace_workspace_changed_event = sbar.add("event", "aerospace_workspace_change")

local dummy_open_spaces = sbar.add("item", "dummy.open_left", properties.dummy_left)

local focused_workspace_id = aerospace_utils.get_focused_workspace()
for _, workspace_id in ipairs(aerospace_utils.list_workspace_ids()) do
	workspace_items[workspace_id] = sbar.add(
		"item",
		"workspace " .. workspace_id,
		properties_for_workspace(workspace_id, workspace_id == focused_workspace_id)
	)
end

local dummy_close_spaces = sbar.add("item", "dummy.close_left", properties.dummy_left)

local bracket = sbar.add("bracket", "bracket.left", { dummy_open_spaces.name, dummy_close_spaces.name }, {
	background = {
		border_color = colours.foreground,
		color = colours.selection,
		corner_radius = 20,
	},
})
bracket:subscribe(aerospace_workspace_changed_event.name, function(env)
	local previous_workspace_id = env.PREV_WORKSPACE
	workspace_items[previous_workspace_id]:set(properties_for_workspace(previous_workspace_id, false))

	---@diagnostic disable-next-line: redefined-local
	local focused_workspace_id = env.FOCUSED_WORKSPACE
	workspace_items[focused_workspace_id]:set(properties_for_workspace(focused_workspace_id, true))
end)
