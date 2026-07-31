---@type LazyPluginSpec
local M = {
  "mvllow/modes.nvim",
  event = "VeryLazy",
}

M.config = function()
  local function get_highlight(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if not ok or vim.tbl_isempty(hl) then
      return nil
    end
    return hl
  end

  local function hex(color)
    if color == nil then
      return nil
    end
    return string.format("#%06x", color)
  end

  local function first_highlight_value(names, key, fallback)
    for _, name in ipairs(names) do
      local hl = get_highlight(name)
      if hl and hl[key] then
        return hex(hl[key])
      end
    end
    return fallback
  end

  local function setup_modes()
    require("modes").setup {
      colors = {
        copy = first_highlight_value({ "DiagnosticWarn", "WarningMsg" }, "fg", "#f5c359"),
        delete = first_highlight_value({ "DiagnosticError", "ErrorMsg" }, "fg", "#c75c6a"),
        change = first_highlight_value({ "DiagnosticError", "ErrorMsg" }, "fg", "#c75c6a"),
        format = first_highlight_value({ "DiagnosticInfo", "Special" }, "fg", "#c79585"),
        insert = first_highlight_value({ "DiagnosticOk", "String" }, "fg", "#78ccc5"),
        replace = first_highlight_value({ "DiagnosticError", "Substitute" }, "fg", "#c75c6a"),
        select = first_highlight_value({ "Visual", "Search" }, "bg", "#9745be"),
        visual = first_highlight_value({ "Visual", "Search" }, "bg", "#9745be"),
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
