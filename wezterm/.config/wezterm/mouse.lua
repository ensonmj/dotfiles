local wezterm = require("wezterm")

return {
  -- Paste on right-click
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
  },
  -- Change the default click behavior so that it only selects
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
  },
  -- CTRL-Click open hyperlinks
  {
    event = {
      Up = {
        streak = 1,
        button = "Left",
      },
    },
    mods = "CTRL",
    action = "OpenLinkAtMouseCursor",
  },
}
