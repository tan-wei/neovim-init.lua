local M = {
  "vim-airline/vim-airline",
  dependencies = {
    "vim-airline/vim-airline-themes",
    "nvim-tree/nvim-web-devicons",
  },
}

M.init = function()
  vim.g.airline_powerline_fonts = 1
end

return M
