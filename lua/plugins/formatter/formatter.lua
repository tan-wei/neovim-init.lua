local M = {
  "mhartington/formatter.nvim",
  enabled = false,
}

M.config = function()
  local util = require "formatter.util"

  require("formmater").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      lua = {
        require("formatter.filetypes.lua").stylua,
      },
      c = {
        require("formatter.filetypes.c").clangformat,
      },
      cpp = {
        require("formatter.filetypes.c").clangformat,
      },
      rust = {
        require("formatter.filetypes.rust").rustfmt,
      },
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace,
      },
    },
  }

  vim.cmd [[
     augroup _auto_format
       autocmd!
       autocmd BufWritePost * FormatWrite
     augroup END
  ]]
end

return M
