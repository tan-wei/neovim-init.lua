local M = {
  "ntpeters/vim-better-whitespace",
}

M.init = function() end
vim.g.better_whitespace_filetypes_blacklist = {
  "diff",
  "git",
  "gitcommit",
  "unite",
  "qf",
  "help",
  "fugitive",
  "minimap",
}

return M
