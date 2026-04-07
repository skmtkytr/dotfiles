local home = os.getenv("HOME")

-- yamb: persistent bookmarks with fzf
require("yamb"):setup({
	bookmarks = {},
	jump_notify = true,
	cli = "fzf",
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	path = home .. "/.config/yazi/bookmark",
})

-- bunny: quick hop menu
require("bunny"):setup({
	hops = {
		{ key = "~", path = "~", desc = "Home" },
		{ key = "/", path = "/" },
		{ key = "c", path = "~/.config", desc = "Config" },
		{ key = "d", path = "~/Downloads", desc = "Downloads" },
		{ key = "g", path = "~/.ghq", desc = "ghq repos" },
		{ key = "D", path = "~/dotfiles", desc = "Dotfiles" },
		{ key = "t", path = "/tmp" },
	},
	desc_strategy = "path",
	ephemeral = true,
	tabs = true,
	notify = false,
	fuzzy_cmd = "fzf",
})
