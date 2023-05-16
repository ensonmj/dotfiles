-- Pull in the wezterm API
local wezterm = require("wezterm")
require("events")

-- use the config_builder which will help provide clearer error messages
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_domain = "WSL:Ubuntu"
  -- config.default_prog = { "wsl.exe" }
end

config.color_scheme = "Dracula (Official)"
-- config.line_height = 1.1
-- config.cell_width = 0.9
config.font_size = 11
-- https://wezfurlong.org/wezterm/config/lua/wezterm/font_with_fallback.html#manual-fallback-scaling
config.font = wezterm.font({ family = "Sarasa Term SC Nerd Font", scale = 1.2 })
config.warn_about_missing_glyphs = false
-- config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.0,
    brightness = 0.9,  -- default is 1.0
}
config.initial_rows = 40
config.initial_cols = 120
config.scrollback_lines = 99999
config.exit_behavior = "Close"
config.launch_menu = require("launch_menu")

-- Window
config.window_decorations = "RESIZE"
config.enable_scroll_bar = true
config.window_background_opacity = 0.94 -- 如果设置为1.0会明显卡顿
config.text_background_opacity = 1.0
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 20
config.colors = {
  tab_bar = {
    background = "#121212",
    active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
    -- inactive_tab = {bg_color = "#222222", fg_color = "#808080"},
    -- inactive_tab_hover = {bg_color = "#EEE8D5",fg_color = "#909090", italic = false},
    -- new_tab = {bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold"},
    -- new_tab_hover = {bg_color = "#1C1B19", fg_color = "#121212", intensity = "Bold"},
  },
}

-- Keys
-- config.disable_default_key_binding = true
config.use_dead_keys = false -- Allow using ^ with single key press.
config.leader = { key = "a", mods = "CTRL" }
config.keys = require("keys")

-- Mouse
config.mouse_bindings = require("mouse")

-- and finally, return the configuration to wezterm
return config
