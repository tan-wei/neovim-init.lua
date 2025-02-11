local M = {
  "gbprod/yanky.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

-- TODO: Integerate with other plugins

M.config = function()
  require("yanky").setup {
    ring = {
      history_length = 200,
    },
    highlight = {
      on_put = false,
      on_yank = false,
      timer = 1000,
    },
  }

  require("telescope").load_extension "yank_history"
end

return M
