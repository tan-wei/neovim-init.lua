local M = {
  "mcauley-penney/visual-whitespace.nvim",
  event = "ModeChanged *:[vV\22]",
}

M.opts = {
  enabled = true,
  highlight = { link = "Visual", default = true },
  match_types = {
    space = true,
    tab = true,
    nbsp = true,
    lead = true,
    trail = true,
  },
  list_chars = {
    space = "·",
    tab = "↦",
    nbsp = "␣",
    lead = "‹",
    trail = "›",
  },
  fileformat_chars = {
    unix = "↲",
    mac = "←",
    dos = "↙",
  },
  ignore = {
    filetypes = {
      "TelescopePrompt",
      "TelescopeResults",
      "trouble",
      "help",
      "alpha",
      "toggleterm",
      "WhichKey",
      "checkhealth",
      "notify",
      "noice",
      "lspinfo",
      "lazy",
      "Outline",
      "fzf",
      "nofile",
      "mason",
    },
    buftypes = {},
  },
}

return M
