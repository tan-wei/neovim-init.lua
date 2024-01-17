local M = {
  "shrikecode/kyotonight.vim",
  lazy = true,
}

M.init = function()
  vim.g.kyotonight_bold = 1
  vim.g.kyotonight_underline = 1
  vim.g.kyotonight_italic = 1
  vim.g.kyotonight_italic_comments = 1
  vim.g.kyotonight_uniform_status_lines = 1
  vim.g.kyotonight_bold_vertical_split_line = 1
  vim.g.kyotonight_cursor_line_number_background = 1
  vim.g.kyotonight_uniform_diff_background = 1
  vim.g.kyotonight_lualine_bold = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kyotonight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
