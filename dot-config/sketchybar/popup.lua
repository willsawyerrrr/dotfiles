local M = {}

function M.toggle_popup(item)
	return function()
		item:set({ popup = { drawing = "toggle" } })
	end
end

return M
