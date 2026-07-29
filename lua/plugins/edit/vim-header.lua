---@type LazyPluginSpec
local M = {
  "alpertuna/vim-header",
}

M.init = function()
  local project_config = require "util.project_config"

  vim.g.header_auto_add_header = project_config.get "header_auto_add_header"
  vim.g.header_auto_update_header = project_config.get "header_auto_update_header"
  vim.g.header_field_filename = project_config.get "header_field_filename"
  vim.g.header_field_project = project_config.get "header_field_project"
  vim.g.header_field_author = project_config.get "header_field_author"
  vim.g.header_field_author_email = project_config.get "header_field_author_email"
  vim.g.header_field_timestamp = project_config.get "header_field_timestamp"
  vim.g.header_field_timestamp_format = project_config.get "header_field_timestamp_format"
  vim.g.header_field_modified_by = project_config.get "header_field_modified_by"
  vim.g.header_alignment = project_config.get "header_alignment"
end

return M
