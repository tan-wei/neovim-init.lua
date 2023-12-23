local M = {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
}

M.opts = {
  priority = 10,
  hide_in_unfocused_buffer = true,
  link_highlights = true,
  sign = {
    enabled = false,
  },
  virtual_text = {
    enabled = false,
  },
  float = {
    enabled = true,
    text = "󰌵",
    hl = "LightBulbFloatWin",
    win_opts = {
      focusable = false,
    },
  },
  status_text = {
    enabled = true,
    text = "󰌵",
    text_unavailable = "",
  },
  number = {
    enabled = false,
  },
  line = {
    enabled = false,
  },
  autocmd = {
    enabled = true,
    updatetime = 200,
    events = { "CursorHold", "CursorHoldI" },
    pattern = { "*" },
  },
  ignore = {
    clients = {},
    ft = {},
    actions_without_kind = false,
  },
}

return M
