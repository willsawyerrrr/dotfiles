local M = {}

--- Run the given aerospace command.
---
--- Returns a file object representing the command's output.
--- It is the responsibility of the caller to close the file.
---
---@param command string The command to run.
---@return file* The command's output.
local function aerospace_command(command)
	local output, err_msg = io.popen("aerospace " .. command)
	if output == nil then
		error("failed to run aerospace command '" .. command .. err_msg)
	end

	return output
end

--- Get the ID of the focused workspace.
---
---@return number The ID of the focused workspace.
function M.get_focused_workspace()
	local output_file = aerospace_command("list-workspaces --focused")

	return output_file:read("*n")
end

--- List the IDs of all workspaces.
---
---@return table List of workspace IDs.
function M.list_workspace_ids()
	local output_file = aerospace_command("list-workspaces --monitor all")

	local workspaces = {}
	for workspace_id in output_file:lines() do
		table.insert(workspaces, tonumber(workspace_id))
	end
	output_file:close()

	return workspaces
end

return M
