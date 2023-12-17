local M = {
  "dkarter/bullets.vim",
  ft = "markdown",
}

M.init = function()
  vim.g.bullets_enabled_file_types = { "markdown" }
  vim.g.bullets_line_spacing = 1
  vim.g.bullets_pad_right = 1
  vim.g.bullets_pad_right = 0
  vim.g.bullets_checkbox_partials_toggle = 1
  vim.g.bullets_checkbox_markers = " .oOX" -- or '✗○◐●✓"
end

return M
