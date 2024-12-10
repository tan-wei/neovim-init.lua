local M = {
  "GnikDroy/projections.nvim",
  branch = "pre_release",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("projections").setup {
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  }

  require("telescope").load_extension "projections"

  local workspace = require "projections.workspace"
  -- Add workspace command
  vim.api.nvim_create_user_command("AddWorkspace", function()
    workspace.add(vim.loop.cwd())
  end, {})
end

return M
