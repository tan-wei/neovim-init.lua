local M = {
  "cryptomilk/nightcity.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  -- table.insert(available_colorschemes, "nightcity")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  on_highlights = function(groups, colors)
    groups.IblIndent = { fg = colors.xgray7, nocombine = true }
    groups.IblScope = { fg = colors.magenta, nocombine = true }
  end,
}

return M
