---@type LazyPluginSpec
local M = {
  "johnfrankmorgan/whitespace.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("whitespace-nvim").setup {
    highlight = "DiffDelete",
    ignored_filetypes = {
      "fzf",
      "fzflua_backdrop",
      "trouble",
      "help",
      "alpha",
      "toggleterm",
      "WhichKey",
      "checkhealth",
      "notify",
      "noice",
      "lspinfo",
      "lazy",
      "Outline",
      "fzf",
      "nofile",
      "mason",
    },
    ignore_terminal = true,
  }
end

return M
