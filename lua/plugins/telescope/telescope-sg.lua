local M = {
  "Marskey/telescope-sg",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("telescope").load_extension "ast_grep"
end

return M
