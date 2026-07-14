---@type LazyPluginSpec
local M = {
  "m4xshen/hardtime.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "Hardtime enable",
}

M.opts = {
  disabled_filetypes = {
    "qf",
    "netrw",
    "NvimTree",
    "lazy",
    "mason",
    "oil",
    "help",
    "Outline",
    "toggleterm",
    "alpha",
    "checkhealth",
    "noice",
    "notify",
    "fugitive",
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
