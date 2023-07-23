local M = {
  "ntpeters/vim-better-whitespace",
}

M.init = function()
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
end

return M
