local M = {
  "LukasPietzschmann/telescope-tabs",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Telescope telescope-tabs list_tabs",
}

M.config = function()
  require("telescope").load_extension "telescope-tabs"
end

return M
