local M = {
  "m-demare/attempt.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  event = { "VeryLazy" },
}

M.config = function()
  require("attempt").setup()
  require("telescope").load_extension "attempt"
end

return M
