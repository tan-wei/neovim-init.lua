local M = {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  },
  event = "BufReadPre",
}

M.init = function()
  vim.opt.list = true
  vim.opt.listchars:append "space:⋅"
  vim.opt.listchars:append "eol:↴"
end

M.config = function()
  -- TODO: This table should import by user config, and shared with other plugins (e.g.,rainbowdelimiters)
  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local ibl = require "ibl"
  local hooks = require "ibl.hooks"

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  vim.g.rainbow_delimiters = { highlight = highlight }

  ibl.setup {
    indent = { char = { "|", "¦", "┆", "┊", "┋" }, tab_char = { "»" }, smart_indent_cap = true, priority = 50 },
    scope = {
      show_start = true,
      show_end = true,
      highlight = highlight,
      char = { "▏" },
    },
    whitespace = { highlight = { "Whitespace", "NonText" }, remove_blankline_trail = true },
    exclude = {
      filetypes = {
        "",
        "NvimTree",
        "Outline",
        "TelescopePrompt",
        "Trouble",
        "Ultest*",
        "alpha",
        "dapui*",
        "dashboard",
        "dbui",
        "floaterm",
        "flutterToolsOutline",
        "fugitive*",
        "git*",
        "help",
        "lazy",
        "log",
        "lspinfo",
        "mason",
        "neogit*",
        "org*",
        "packer",
        "startify",
        "term",
        "undotree",
        "vista",
      },
      buftypes = { "terminal", "nofile" },
    },
  }
end

return M
