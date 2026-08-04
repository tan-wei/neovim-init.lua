---@type LazyPluginSpec
local M = {
  "mvllow/modes.nvim",
  event = "VeryLazy",
}

M.config = function()
  local highlight = require "util.highlight"

  local function setup_modes()
    require("modes").setup {
      colors = {
        copy = highlight.first_hex({ "DiagnosticWarn", "WarningMsg" }, "fg", "#f5c359"),
        delete = highlight.first_hex({ "DiagnosticError", "ErrorMsg" }, "fg", "#c75c6a"),
        change = highlight.first_hex({ "DiagnosticError", "ErrorMsg" }, "fg", "#c75c6a"),
        format = highlight.first_hex({ "DiagnosticInfo", "Special" }, "fg", "#c79585"),
        insert = highlight.first_hex({ "DiagnosticOk", "String" }, "fg", "#78ccc5"),
        replace = highlight.first_hex({ "DiagnosticError", "Substitute" }, "fg", "#c75c6a"),
        select = highlight.first_hex({ "Visual", "Search" }, "bg", "#9745be"),
        visual = highlight.first_hex({ "Visual", "Search" }, "bg", "#9745be"),
      },
      ignore = {
        "NvimTree",
        "Outline",
        "TelescopePrompt",
        "TelescopeResults",
        "Trouble",
        "alpha",
        "checkhealth",
        "dapui_breakpoint",
        "dapui_console",
        "dapui_scopes",
        "dapui_stacks",
        "dapui_watches",
        "dbui",
        "fugitive",
        "gitcommit",
        "help",
        "lazy",
        "lspinfo",
        "mason",
        "neogit",
        "noice",
        "notify",
        "qf",
        "toggleterm",
        "trouble",
        "undotree",
      },
      set_number = false,
      set_cursor = true,
      set_cursorline = true,
      set_signcolumn = false,
    }
  end

  setup_modes()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserModesHighlights", { clear = true }),
    callback = setup_modes,
  })
end

return M
