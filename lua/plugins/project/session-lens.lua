local M = {
  "rmagatti/session-lens",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "rmagatti/auto-session",
  },
  cmd = "SearchSession",
}

M.config = function()
  require("session-lens").setup {
    path_display = { "shorten" },
  }
  require("telescope").load_extension "session-lens"
end

return M
