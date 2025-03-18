local double_press = require("altDoublePress")

local open = function()
	local appName = "Neovide"
	local app = hs.application.find(appName, true)

	if app == nil or app:isHidden() or not (app:isFrontmost()) then
		hs.application.launchOrFocus(appName)
	else
		app:hide()
	end
end

double_press.timeFrame = 0.5
double_press.action = open

-- Neovide configuration
hs.hotkey.bind({ "ctrl", "shift" }, "z", function()
	-- Get current space
	local currentSpace = hs.spaces.focusedSpace()
	-- Get neovide app
	local app = hs.application.get("neovide")
	-- If app already open:
	if app then
		-- If no main window, then open a new window
		if not app:mainWindow() then
			app:selectMenuItem("New OS Window", true)
		-- If app is already in front, then hide it
		elseif app:isFrontmost() then
			app:hide()
		-- If there is a main window somewhere, bring it to current space and to
		-- front
		else
			-- First move the main window to the current space
			hs.spaces.moveWindowToSpace(app:mainWindow(), currentSpace)
			-- Activate the app
			app:activate()
			-- Raise the main window and position correctly
			app:mainWindow():raise()
		end
	-- If app not open, open it
	else
		hs.application.launchOrFocus("neovide")
		app = hs.application.get("neovide")
	end
	-- hs.spaces.gotoSpace(currentSpace)
end)
