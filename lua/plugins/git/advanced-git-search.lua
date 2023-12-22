local M = {
  "aaronhallaert/advanced-git-search.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = { "AdvancedGitSearch" },
}

M.config = function()
  require("advanced_git_search.fzf").setup {
    diff_plugin = "diffview",
  }
  require("telescope").load_extension "advanced_git_search"
end
return M
