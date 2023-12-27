local M = {
  "alpertuna/vim-header",
  cmd = { "AddHeader", "AddMinHeader" },
}

M.init = function()
  vim.g.header_auto_add_header = 0
  vim.g.header_auto_update_header = 0
  vim.g.header_field_filename = 1
  vim.g.header_field_project = "TODO: Project Name"
  vim.g.header_field_author = "Winterreise"
  vim.g.header_field_author_email = "winterreise.tanwei@gmail.com"
  vim.g.header_field_timestamp = 1
  vim.g.header_field_timestamp_format = "%Y-%m-%d %H:%M:%S"
  vim.g.header_field_modified_by = 1
end

return M
