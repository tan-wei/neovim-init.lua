local M = {
  "jedrzejboczar/toggletasks.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "ToggleTasksInfo", "ToggleTasksConvert" },
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("toggletasks").setup {
    silent = true,
    search_paths = {
      "toggletasks",
      ".toggletasks",
      ".nvim/toggletasks",
    },
  }
  require("telescope").load_extension "toggletasks"
end

return M
