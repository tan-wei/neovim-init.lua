local status_ok, modicator = pcall(require, "modicator")
if not status_ok then
  return
end

-- TODO: modicator.nvim now works buggy with lualine
modicator.setup {
  show_warnings = false,
  integration = {
    lualine = {
      mode_section = "lualine_b",
      highlight = "fg",
    },
  },
}
