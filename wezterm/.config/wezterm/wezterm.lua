-- Pull in the wezterm API
local wezterm = require("wezterm")
local launch_menu = require("launch_menu")
require("keys")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane

  local index = ""
  if #tabs > 1 then
    index = string.format("%d: ", tab.tab_index + 1)
  end

  local process = basename(pane.foreground_process_name)

  return { {
    Text = " " .. index .. process .. " ",
  } }
end)

-- Initial startup
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- This is where you actually apply your config choices
config.launch_menu = launch_menu
config.color_scheme = "Batman"
config.font = wezterm.font_with_fallback({ "FiraMono Nerd Font Mono", "monospace", monospace })
config.font_size = 11 
config.keys = keyBind()

-- Window
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = true
config.window_background_opacity = 0.98 -- 如果设置为1.0会明显卡顿
-- config.window_padding = {
--   left = 5,
--   right = 5,
--   top = 5,
--   bottom = 5,
-- }
config.window_background_image_hsb = {
  brightness = 0.8,
  hue = 1.0,
  saturation = 1.0,
}
config.window_close_confirmation = "NeverPrompt"

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.tab_max_width = 25
config.scrollback_lines = 99999

-- Keys
config.disable_default_key_bindings = false
-- Allow using ^ with single key press.
config.use_dead_keys = false

config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 1.0,
}

config.mouse_bindings = { -- Paste on right-click
  {
    event = {
      Down = {
        streak = 1,
        button = "Right",
      },
    },
    mods = "NONE",
    action = wezterm.action({
      PasteFrom = "Clipboard",
    }),
  }, -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = {
      Up = {
        streak = 1,
        button = "Left",
      },
    },
    mods = "NONE",
    action = wezterm.action({
      CompleteSelection = "PrimarySelection",
    }),
  }, -- CTRL-Click open hyperlinks
  {
    event = {
      Up = {
        streak = 1,
        button = "Left",
      },
    },
    mods = "CMD",
    action = "OpenLinkAtMouseCursor",
  },
}

-- and finally, return the configuration to wezterm
return config
