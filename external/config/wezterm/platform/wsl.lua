local M = {}

function M.apply_to_config(config, wezterm)
  config.font = wezterm.font_with_fallback({
    "Fira Code Nerd Font",
    "Sarasa Gothic Mono",
  })
  config.font_size = 10.0
end

return M