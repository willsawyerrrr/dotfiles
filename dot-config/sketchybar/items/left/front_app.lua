local colours = require("colours")
local properties = require("properties")

local function get_absolute_path(path)
	return io.popen("realpath '" .. path .. "'", "r"):read("*l")
end

---@class DisplayDetails
---@field label string
---@field icon_image string
---@field should_draw boolean
---@field icon_scale number

---App names which should be displayed as the Touch ID icon.
local touch_id_apps = {
	coreautha = true,
}

---Return whether the app with the given name should be displayed as the Touch ID icon.
---@param app_name string The name of the app.
---@return boolean Whether the app should be displayed as the Touch ID icon.
local function is_touch_id_app(app_name)
	return touch_id_apps[app_name]
end

---App names which should not be displayed.
local hidden_apps = {
	loginwindow = true,
}

---Return whether the app with the given name should be hidden.
---@param app_name string The name of the app.
---@return boolean Whether the app should be hidden.
local function is_hidden_app(app_name)
	return hidden_apps[app_name]
end

---@return DisplayDetails
local function get_display_details(app_name)
	if is_touch_id_app(app_name) then
		return {
			label = "Touch ID",
			icon_image = get_absolute_path("./icons/touch_id.png"),
			should_draw = true,
			icon_scale = 0.08,
		}
	elseif is_hidden_app(app_name) then
		return {
			should_draw = false,
		}
	end

	return {
		label = app_name,
		icon_image = "app." .. app_name,
		should_draw = true,
	}
end

local front_app = sbar.add("item", "front_app", properties.for_left_pill(colours.red))
front_app:subscribe("front_app_switched", function(env)
	local display_details = get_display_details(env.INFO)

	local scale = display_details.icon_scale or 0.8

	front_app:set({
		drawing = display_details.should_draw and "on" or "off",
		label = display_details.label,
		icon = {
			background = {
				image = {
					string = display_details.icon_image,
					scale = scale,
				},
			},
		},
	})
end)
