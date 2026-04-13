local M = {}

local function is_table(maybe_table)
	return type(maybe_table) == "table"
end

--- Merges the given tables.
---
--- If a given key exists as a table in one input table and a string in the other,
--- the string value is assigned to the `string` key of the table value, preventing
--- the need to do this explicitly.
---
---@param table1 table The first table to merge.
---@param table2 table The second table to merge.
---@return table
function M.merge_tables(table1, table2)
	local result = {}

	for k, v in pairs(table1) do
		result[k] = v
	end

	for k, v in pairs(table2) do
		local existing_value_is_table = is_table(result[k])
		local new_value_is_table = is_table(v)

		if existing_value_is_table and new_value_is_table then
			result[k] = M.merge_tables(result[k], v)
		elseif existing_value_is_table then
			result[k] = M.merge_tables(result[k], { string = v })
		elseif new_value_is_table then
			result[k] = M.merge_tables(v, { string = result[k] })
		else
			result[k] = v
		end
	end

	return result
end

function M.use_battery_details(callback)
	return function()
		sbar.exec("pmset -g batt", function(battery_info)
			local found, _, charge = string.find(battery_info, "(%d+)%%")
			if found then
				charge = tonumber(charge)
			end

			local charging = string.find(battery_info, "AC Power")

			callback(charging, charge)
		end)
	end
end

return M
