local M = {
  "m4xshen/hardtime.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = "Hardtime enable",
}

M.opts = {
  disabled_filetypes = {
    "qf",
    "netrw",
    "NvimTree",
    "lazy",
    "mason",
    "oil",
  },
}

return M
