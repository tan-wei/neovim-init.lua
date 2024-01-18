local M = {
  "decaycs/decay.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "decay")
  table.insert(available_colorschemes, "dark-decay")
  table.insert(available_colorschemes, "decayce")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("decay").setup {
    style = "dark",
  }
  -- NOTE: Work around due to the colorscheme does not set name
  vim.cmd [[let g:colors_name = "decay"]]
end

return M
