local M = {
  "kevinhwang91/nvim-fundo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  build = function()
    require("fundo").install()
  end,
  lazy = false,
}

M.init = function()
  vim.o.undofile = true
end

M.config = function()
  require("fundo").setup()
end

return M
