---@type LazyPluginSpec
local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

M.init = function()
  local highlight = require "util.highlight"

  local function set_illuminate_highlights()
    local text_sp = highlight.first({ "Comment", "NonText" }, "fg")
    local normal_bg = highlight.first({ "Normal", "NormalFloat", "CursorLine" }, "bg")
    local read_sp = highlight.first({ "DiagnosticInfo", "Function", "Identifier" }, "fg")
    local write_bg = highlight.first({ "DiagnosticError", "DiagnosticWarn", "Statement" }, "fg")

    vim.api.nvim_set_hl(0, "IlluminatedWordText", { sp = text_sp, underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { sp = read_sp, underline = true })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = normal_bg, bg = write_bg, bold = true })
  end

  set_illuminate_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserIlluminateHighlights", { clear = true }),
    callback = set_illuminate_highlights,
  })
end

M.config = function()
  require("illuminate").configure {
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },
    delay = 100,
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "NvimTree",
      "alpha",
    },
  }
end

return M
