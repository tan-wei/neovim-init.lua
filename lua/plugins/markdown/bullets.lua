---@type LazyPluginSpec
local M = {
  "bullets-vim/bullets.vim",
  ft = "markdown",
}

M.init = function()
  local project_config = require "util.project_config"

  vim.g.bullets_enabled_file_types = project_config.get "bullets_enabled_file_types"
  vim.g.bullets_line_spacing = project_config.get "bullets_line_spacing"
  vim.g.bullets_pad_right = project_config.get "bullets_pad_right"
  vim.g.bullets_checkbox_partials_toggle = project_config.get "bullets_checkbox_partials_toggle"
  vim.g.bullets_checkbox_markers = project_config.get "bullets_checkbox_markers"
  vim.g.bullets_delete_last_bullet_if_empty = project_config.get "bullets_delete_last_bullet_if_empty"
  vim.g.bullets_auto_indent_after_colon = project_config.get "bullets_auto_indent_after_colon"
  vim.g.bullets_outline_levels = project_config.get "bullets_outline_levels"
end

return M
