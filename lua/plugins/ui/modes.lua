local M  = {
  "mvllow/modes.nvim",
  event = "ModeChanged",
}

M.config = function()
  require('modes').setup({
    ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
  })
end

return M
