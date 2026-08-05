---@type LazyPluginSpec
local M = {
  "AlexvZyl/nordic.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nordic")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("nordic").setup {
    on_highlight = function(highlights, palette)
      highlights.PmenuSel = {
        fg = palette.white1,
        bg = palette.blue2,
        bold = true,
      }
    end,
  }
  vim.cmd.colorscheme "nordic"
end

return M
