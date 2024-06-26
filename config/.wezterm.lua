-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- config.font = wezterm.font 'Fira Code'
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.

-- config.harfbuzz_features = {"zero" , "ss01", "cv05"}

-- config.disable_default_key_bindings = true
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
	-- paste from the clipboard
	{ key = "V", mods = "SUPER", action = act.PasteFrom("Clipboard") },

	-- paste from the primary selection
	{ key = "V", mods = "SUPER", action = act.PasteFrom("PrimarySelection") },
}

config.font = wezterm.font_with_fallback({
	--   -- family = 'JetBrains Mono',
	-- family = 'FiraCode Nerd Font Mono',
	{
		family = "UDEV Gothic 35NFLG",
		weight = "Bold",
		-- harfbuzz_features = { "zero", "ss01", "cv05" },
		harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
		-- offset = { x = 0, y = 1 }, -- not working
	},
})
config.font_size = 14

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = "Monokai Pro (Gogh)"
config.window_background_opacity = 1.0
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_frame = { border_bottom_height = 0 }

-- and finally, return the configuration to wezterm
return config
