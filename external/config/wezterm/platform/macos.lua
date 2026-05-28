local M = {}

function M.apply_to_config(config, wezterm)
  config.font = wezterm.font_with_fallback {
    "Agave Nerd Font",
    "Sarasa Gothic SC",
  }
  config.font_size = 14.0
  config.native_macos_fullscreen_mode = true
end

return M
