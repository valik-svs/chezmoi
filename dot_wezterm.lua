local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action

local function getAppearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function colorSchemeForAppearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	end

	return "VSCodeLight+ (Gogh)"
end

local appearance = getAppearance()
local isDarkAppearance = appearance:find("Dark") ~= nil

local theme = isDarkAppearance
		and {
			tab_bar_bg = "#1e1e2e",
			active_tab_bg = "#11111b",
			active_tab_fg = "#cdd6f4",
			inactive_tab_bg = "#313244",
			inactive_tab_fg = "#a6adc8",
			hover_tab_bg = "#45475a",
			titlebar_bg = "#1e1e2e",
			titlebar_fg = "#cdd6f4",
		}
	or {
		tab_bar_bg = "#f3f3f3",
		active_tab_bg = "#ffffff",
		active_tab_fg = "#1f2328",
		inactive_tab_bg = "#e8e8e8",
		inactive_tab_fg = "#5f6a73",
		hover_tab_bg = "#dcdcdc",
		titlebar_bg = "#f3f3f3",
		titlebar_fg = "#1f2328",
	}

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

----------------- NEOVIM NAVIGATION --------------
local function isViProcess(pane)
	-- get_foreground_process_name On Linux, macOS and Windows,
	-- the process can be queried to determine this path. Other operating systems
	-- (notably, FreeBSD and other unix systems) are not currently supported
	return pane:get_foreground_process_name():find("n?vim") ~= nil or pane:get_title():find("n?vim") ~= nil
	-- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = "CTRL" }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

wezterm.on("update-status", function(window)
	-- Grab the utf8 character for the "powerline" left facing
	-- solid arrow.
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Grab the current window's configuration, and from it the
	-- palette (this is the combination of your chosen colour scheme
	-- including any overrides).
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = "none" } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. wezterm.hostname() .. " " },
	}))
end)

-- for neovim zen mode
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return {
	default_prog = { "/opt/homebrew/bin/zsh", "-l" },
	-- window_decorations = "RESIZE",
	inactive_pane_hsb = {
		saturation = 0.8,
		brightness = 0.7,
	},
	color_scheme = colorSchemeForAppearance(appearance),
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 14,
	line_height = 1.2,
	use_dead_keys = false,
	scrollback_lines = 5000,
	adjust_window_size_when_changing_font_size = false,
	-- hide_tab_bar_if_only_one_tab = true,
	window_frame = {
		font = wezterm.font({ family = "Noto Sans", weight = "Regular" }),
		font_size = 12,
		active_titlebar_bg = theme.titlebar_bg,
		inactive_titlebar_bg = theme.titlebar_bg,
		active_titlebar_fg = theme.titlebar_fg,
		inactive_titlebar_fg = theme.inactive_tab_fg,
	},
	colors = {
		tab_bar = {
			background = theme.tab_bar_bg,
			active_tab = {
				bg_color = theme.active_tab_bg,
				fg_color = theme.active_tab_fg,
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = theme.inactive_tab_bg,
				fg_color = theme.inactive_tab_fg,
			},
			inactive_tab_hover = {
				bg_color = theme.hover_tab_bg,
				fg_color = theme.active_tab_fg,
			},
			new_tab = {
				bg_color = theme.tab_bar_bg,
				fg_color = theme.inactive_tab_fg,
			},
			new_tab_hover = {
				bg_color = theme.hover_tab_bg,
				fg_color = theme.active_tab_fg,
			},
		},
	},
	set_environment_variables = {
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
		SYSTEM_APPEARANCE = isDarkAppearance and "dark" or "light",
	},
	window_background_opacity = isDarkAppearance and 0.92 or 1.0,
	macos_window_background_blur = isDarkAppearance and 40 or 0,
	window_decorations = "RESIZE|INTEGRATED_BUTTONS",
	--disable_default_key_bindings = true,
	leader = { key = "b", mods = "CMD", timeout_milliseconds = 2000 },
	keys = {
		{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
		{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
		{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
		{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
		{ key = "9", mods = "ALT", action = act.ActivateTab(-1) },
		{ key = "\\", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "\\", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- { key = "k", mods = "CTRL|ALT", action = act.CopyMode("PriorMatch") },
		-- { key = "j", mods = "CTRL|ALT", action = act.CopyMode("NextMatch") },
		{ key = "l", mods = "ALT", action = wezterm.action.ShowLauncher },
		{ key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
		{ key = "LeftArrow", mods = "CMD|OPT", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "CMD|OPT", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
		{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
		{ key = "LeftArrow", mods = "CMD", action = act.SendString("\x01") },
		{ key = "RightArrow", mods = "CMD", action = act.SendString("\x05") },
		{ key = "LeftArrow", mods = "SHIFT", action = act.SendKey({ key = "LeftArrow" }) },
		{ key = "RightArrow", mods = "SHIFT", action = act.SendKey({ key = "RightArrow" }) },
		--{ key = "LeftArrow", mods = "OPT", action = act.EmitEvent("ActivatePaneDirection-left") },
		--{ key = "DownArrow", mods = "OPT", action = act.EmitEvent("ActivatePaneDirection-down") },
		--{ key = "UpArrow", mods = "OPT", action = act.EmitEvent("ActivatePaneDirection-up") },
		--{ key = "RightArrow", mods = "OPT", action = act.EmitEvent("ActivatePaneDirection-right") },
		{
			key = ",",
			mods = "SUPER",
			action = wezterm.action.SpawnCommandInNewTab({
				cwd = wezterm.home_dir,
				args = { "nvim", wezterm.config_file },
			}),
		},
	},
}
