local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

M.init = function()
  vim.cmd [[
    augroup _illuminate
      autocmd!
      autocmd VimEnter * hi link illuminatedWord CursorLine
    augroup END

    augroup _illuminate
      autocmd!
      autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
    augroup END
  ]]
end

M.config = function()
  require("illuminate").configure {
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },
    delay = 100,
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "NvimTree",
      "alpha",
    },
  }
end

return M
