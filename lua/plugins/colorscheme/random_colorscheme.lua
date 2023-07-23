local M = {
  "Sammyalhashe/random_colorscheme.vim",
}

M.config = function()
  vim.g.random_scheme = 1
  vim.g.random_disabled = 0
  vim.g.available_colorschemes {
    "tokyonight",
  }
end

return M
