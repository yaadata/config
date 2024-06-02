local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- styles

config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9
config.native_macos_fullscreen_mode = true
config.scrollback_lines = 3000
config.use_fancy_tab_bar = false

-- workspace
config.default_workspace = "home"
config.status_update_interval = 1000

wezterm.on("update-right-status", function(window, pane)
	-- workspace name
	local stat = window:active_workspace()

	if window:active_key_table() then
		stat = window:active_key_table()
	end
	if window:leader_is_active() then
		stat = "LDR"
	end

	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	local cwd = basename(pane:get_current_working_dir().file_path)
	local cmd = basename(pane:get_foreground_process_name())
	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.custom_folder_open .. "  " .. cwd },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
	}))
end)
return config
