---@type LazyPluginSpec
local M = {
  "abecodes/tabout.nvim",
  dependencies = vim.g.completion_engine ~= "blink" and {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
  } or {
    "nvim-treesitter/nvim-treesitter",
  },
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  opts = {
    tabkey = vim.g.completion_engine == "blink" and "" or "<Tab>",
    backwards_tabkey = vim.g.completion_engine == "blink" and "" or "<S-Tab>",
    act_as_tab = true,
    act_as_shift_tab = false,
    default_tab = "<C-t>",
    default_shift_tab = "<C-d>",
    enable_backwards = true,
    completion = vim.g.completion_engine ~= "blink",
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = "`", close = "`" },
      { open = "(", close = ")" },
      { open = "[", close = "]" },
      { open = "{", close = "}" },
    },
    ignore_beginning = true,
    exclude = {},
  },
}

return M
