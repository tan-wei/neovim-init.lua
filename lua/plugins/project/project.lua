local M = {
  "ahmedkhalf/project.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("project_nvim").setup {
    active = true,
    manual_mode = false,
    detection_methods = { "pattern" },
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
    show_hidden = false,
    silent_chdir = true,
    ignore_lsp = {},
    scope_chdir = 'global', -- global, tab, win
    datapath = vim.fn.stdpath "data",
  }

  require("telescope").load_extension "projects"
end

return M
