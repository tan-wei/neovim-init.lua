local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

M.config = function()
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end

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
    },
  }

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

return M
