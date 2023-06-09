local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

function M.setup(config)
  config.mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = act.CompleteSelection("PrimarySelection"),
    },
    -- select to copy(not wezterm copy mode), and paste if don't select anything
    {
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ""
        if has_selection then
          window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(act.PasteFrom("Clipboard"), pane)
        end
      end),
    },
    -- CTRL-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = act.OpenLinkAtMouseCursor,
    },
    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    -- https://wezfurlong.org/wezterm/config/mouse.html?highlight=Ctrl-click#gotcha-on-binding-an-up-event-only
    {
      event = { Down = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = act.Nop,
    },
    -- Grap the semantic zone when triple click
    {
      event = { Down = { streak = 3, button = "Left" } },
      mode = "NONE",
      action = act.SelectTextAtMouseCursor("SemanticZone"),
    },
  }
end

return M
