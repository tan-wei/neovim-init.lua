local M = {
  "ray-x/navigator.lua",
  dependencies = {
    {
      "ray-x/guihua.lua",
      build = function()
        if not require("util.os").is_windows() then
          local job = require "plenary.job"
          job
            :new({
              command = "make",
              cwd = vim.fn.stdpath "data" .. "/lazy/guihua.lua/lua/fzy",
            })
            :sync()
        end
      end,
    },
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "LspAttach",
  enabled = false, -- NOTE: Now it depends on main banch with nvim-treesitter
}

M.opts = {
  lsp = {
    disable_lsp = "all",
  }
}

return M
