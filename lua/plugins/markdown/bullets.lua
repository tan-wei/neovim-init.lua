local M = {
  "dkarter/bullets.vim",
  ft = "markdown",
}

M.init = function()
  vim.g.bullets_enabled_file_types          = { "markdown" }
  vim.g.bullets_line_spacing                = 1 -- no blank lines
  vim.g.bullets_pad_right                   = 0
  vim.g.bullets_checkbox_partials_toggle    = 1
  vim.g.bullets_checkbox_markers            = " .oOX" -- or '✗○◐●✓"
  vim.g.bullets_delete_last_bullet_if_empty = 1
  vim.g.bullets_auto_indent_after_colon     = 1
  vim.g.bullets_outline_levels              = { 'std-', 'std*', 'std+' }
end

return M
