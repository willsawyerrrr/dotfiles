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
			corner_radius = 16,
			drawing = drawing,
			height = 24,
		},
		label = {
			string = workspace_id,
			padding_left = 8,
			padding_right = 10,
		},
		padding_left = 1,
		padding_right = 1,
		click_script = "aerospace workspace " .. workspace_id,
	}

	if not focused and aerospace_utils.is_workspace_empty(workspace_id) then
		workspace_properties["drawing"] = "off"
	else
		workspace_properties["drawing"] = "on"
	end

	return workspace_properties
end

local aerospace_workspace_changed_event = sbar.add("event", "aerospace_workspace_change")
local aerospace_window_moved_event = sbar.add("event", "aerospace_window_moved")

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
bracket:subscribe(aerospace_window_moved_event.name, function(env)
	--- Only need to update the destination workspace, since we want the currently
	--- focused workspace to remain drawn regardless of whether we've just moved
	--- the last window out of it.
	--- If we have just moved the last window out of the focused workspace, it'll
	--- be hidden when we next change focus.
	local destination_workspace_id = env.DESTINATION_WORKSPACE
	workspace_items[destination_workspace_id]:set(properties_for_workspace(destination_workspace_id, false))
end)
