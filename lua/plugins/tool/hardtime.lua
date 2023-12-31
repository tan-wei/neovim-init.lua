local M = {
  "m4xshen/hardtime.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = "Hardtime",
}

M.opts = {
  enables = false,
  disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
}

return M
