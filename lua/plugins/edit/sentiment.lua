local M = {
  "utilyre/sentiment.nvim",
  event = "VeryLazy",
}

M.init = function()
  -- `matchparen.vim` needs to be disabled manually in case of lazy loading
  vim.g.loaded_matchparen = 1
end

return M
