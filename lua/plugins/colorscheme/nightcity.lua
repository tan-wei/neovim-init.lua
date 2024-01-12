local M = {
  "cryptomilk/nightcity.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nightcity")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  on_highlights = function(groups, colors)
    -- NOTE: Make indent-blankline.nvim work, see: https://github.com/cryptomilk/nightcity.nvim/issues/4
    groups.NonText = groups.Whitespace
  end,
}

return M
