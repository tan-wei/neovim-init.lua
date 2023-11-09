local M = {
  "ibhagwan/fzf-lua",
  dependencies = {
    { "junegunn/fzf", build = "./install --bin" },
    "nvim-tree/nvim-web-devicons",
  },
}

M.init = function() end

return M
