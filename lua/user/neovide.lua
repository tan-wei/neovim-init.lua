local M = {}

M.setup = function()
  if require("util.os").is_macos() then
    vim.o.guifont = "DejaVuSansM Nerd Font:h14"
  else
    vim.o.guifont = "Hasklug Nerd Font:h8:#e-subpixelantialias"
  end

  vim.g.neovide_remember_window_size = true
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_refresh_rate = 80
  vim.g.neovide_cursor_animate_in_insert_mode = true
end

return M
