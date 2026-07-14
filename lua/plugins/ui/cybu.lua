---@type LazyPluginSpec
local M = {
  "ghillb/cybu.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  exclude = {
    "fugitive",
    "qf",
    "help",
    "NvimTree",
    "Outline",
    "toggleterm",
    "lazy",
    "mason",
    "alpha",
    "checkhealth",
    "noice",
    "notify",
    "neogit",
    "undotree",
    "trouble",
    "TelescopePrompt",
    "TelescopeResults",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
}

return M
