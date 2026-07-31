---@type LazyPluginSpec
local M = {
  "nvim-mini/mini.nvim",
  event = "VeryLazy",
}

local function apply_highlights()
  local function get_hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
  end

  local normal = get_hl "Normal"
  local diagnostic_warn = get_hl "DiagnosticWarn"
  local warning_msg = get_hl "WarningMsg"
  local search = get_hl "Search"
  local inc_search = get_hl "IncSearch"
  local visual = get_hl "Visual"

  vim.api.nvim_set_hl(0, "UnicodeHighlight", {
    fg = diagnostic_warn.fg or warning_msg.fg or inc_search.bg or normal.fg or "#ffd866",
    bg = search.bg or inc_search.bg or visual.bg or "#6b5300",
    bold = true,
  })
end

M.config = function()
  apply_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("unicode-highlight", { clear = true }),
    callback = apply_highlights,
  })

  require("mini.hipatterns").setup {
    highlighters = {
      suspicious_unicode = require("util.unicode_highlight").highlighter(),
    },
  }

  -- Split and join arguments (gS to toggle)
  require("mini.splitjoin").setup()

  -- 2D cursor jump within visible lines
  require("mini.jump2d").setup()

  -- Text edit operators (g= evaluate, gm multiply, gs sort)
  -- gx (exchange) disabled: conflicts with gx.nvim
  -- gr (replace) disabled: conflicts with LSP references mapping
  require("mini.operators").setup {
    exchange = { prefix = "" },
    replace = { prefix = "" },
  }

  -- Track and reuse file system visits
  require("mini.visits").setup()
end

return M
