local M = {
  "VidocqH/auto-indent.nvim",
  -- NOTE: Lazy load will make it not work
}

M.config = function()
  require("auto-indent").setup {
    lightmode = true,
    indentexpr = function(lnum)
      return require("nvim-treesitter.indent").get_indent(lnum)
    end,
    ignore_filetype = {},
  }
end

return M
