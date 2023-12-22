local M = {
  "judaew/ronny.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ronny")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("ronny").setup {
    display = {
      monokai_original = false,
      only_CursorLineNr = true,
      hi_relativenumber = true,
      hi_unfocus_window = true,
      hi_formatted_text = true,
      hi_comment_italic = true,
    },
  }
end

return M
