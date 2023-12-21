local M = {
  "andymass/vim-matchup",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- event = "BufReadPost", -- FIXME: Any lazy load will cause problem
}

M.init = function()
  vim.g.loaded_matchit = 1
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

return M
