---@type LazyPluginSpec
local M = {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
}

M.opts = {
  enabled = true,
  display_virtual_text = false,
  date_format = "%r",
  message_template = "<author> (<date>)",
  ignored_filetypes = {
    "markdown",
    "NvimTree",
    "Outline",
    "qf",
    "help",
    "toggleterm",
    "lazy",
    "mason",
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
  delay = 1000,
  use_blame_commit_file_urls = true,
}

return M
