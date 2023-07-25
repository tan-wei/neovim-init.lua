local M = {
  "preservim/vim-markdown",
}

M.init = function()
  vim.g.vim_markdown_math = 1
  vim.g.vim_markdown_toc_autofit = 1
  vim.g.vim_markdown_folding_disabled = 1
end

return M
