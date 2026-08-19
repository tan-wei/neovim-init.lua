---@type LazyPluginSpec
local M = {
  "aaronhallaert/advanced-git-search.nvim",
  dependencies = {
    "tpope/vim-fugitive",
    "dlyongemallo/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = { "AdvancedGitSearch" },
}

M.config = function()
  require("advanced_git_search.fzf").setup {
    diff_plugin = "diffview",
  }
end
return M
