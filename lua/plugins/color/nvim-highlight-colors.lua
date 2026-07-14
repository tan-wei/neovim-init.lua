---@type LazyPluginSpec
local M = {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
}

M.opts = {
  exclude_filetypes = {
    "qf",
    "help",
    "lazy",
    "mason",
    "checkhealth",
    "noice",
    "notify",
    "NvimTree",
    "Outline",
    "toggleterm",
    "fugitive",
    "neogit",
    "undotree",
    "alpha",
    "trouble",
    "TelescopePrompt",
    "TelescopeResults",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
  exclude_buftypes = {
    "nofile",
    "prompt",
    "popup",
    "terminal",
    "quickfix",
  },
}

return M
