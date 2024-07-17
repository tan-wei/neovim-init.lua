local M = {
  "mvllow/modes.nvim",
  event = "ModeChanged",
}

M.config = function()
  require("modes").setup {
    ignore_filetypes = { "NvimTree", "TelescopePrompt" },
    set_number = false,
    set_cursor = true,
    set_cursorline = false,
  }
end

return M
