-- Only values that differ from Neovide's built-in defaults are set here, so
-- upstream default changes get picked up automatically. Previously set but
-- redundant (removed): remember_window_size, text_gamma, text_contrast,
-- refresh_rate, cursor_animate_in_insert_mode.
---@type { setup: fun() }
local M = {}

M.setup = function()
  if require("util.os").is_macos() then
    vim.o.guifont = "DejaVuSansM Nerd Font:h14"
  else
    vim.o.guifont = "Hasklug Nerd Font:h8:#e-subpixelantialias"
    -- Required for `#e-subpixelantialias` above to take effect: the default
    -- "Unknown" silently disables subpixel antialiasing. Use "BGRH" if glyph
    -- edges show color fringing on a flipped panel.
    vim.g.neovide_pixel_geometry = "RGBH"
  end

  vim.g.neovide_cursor_vfx_mode = "wireframe"
  -- Hide the pointer while typing; it reappears as soon as the mouse moves.
  vim.g.neovide_hide_mouse_when_typing = true
  -- Round floating-window corners, as a fraction of line height (0.0 = off).
  vim.g.neovide_floating_corner_radius = 0.2
  -- Neovide pads the sub-cell strip below the grid with the bottom row's
  -- background color, so unless the window height is a whole multiple of the
  -- cell height the statusline or tabline background paints a few extra pixels
  -- past its text. Disabled so those backgrounds stop at the grid rows; the
  -- leftover strip then keeps the normal background instead.
  vim.g.neovide_fill_bottom_background = false
end

return M
