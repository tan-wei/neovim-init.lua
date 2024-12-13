local M = {
  "johnfrankmorgan/whitespace.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("whitespace-nvim").setup {
    highlight = "DiffDelete",
    ignored_filetypes = {
      "TelescopePrompt",
      "TelescopeResults",
      "Trouble",
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
    },
    ignore_terminal = true,
  }
end

return M
