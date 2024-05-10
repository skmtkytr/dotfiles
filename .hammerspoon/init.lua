local double_press = require("altDoublePress")

local open_alacritty = function()
	local appName = "Alacritty"
	local app = hs.application.find(appName, true)

	if app == nil or app:isHidden() or not (app:isFrontmost()) then
		hs.application.launchOrFocus(appName)
	else
		app:hide()
	end
end

double_press.timeFrame = 0.5
double_press.action = open_alacritty
