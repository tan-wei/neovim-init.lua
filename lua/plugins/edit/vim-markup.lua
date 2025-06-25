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
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_hi_surround_always = 1
end

return M
