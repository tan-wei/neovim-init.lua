local M = {
  "ray-x/navigator.lua",
  dependencies = {
    {
      "ray-x/guihua.lua",
      build = function()
        if vim.uv.os_uname().sysname ~= "Windows_NT" then
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
  },
  cmd = {
    "LspToggleFmt",
    "LspKeymaps",
    "Nctags",
    "LspRestart",
    "LspToggleFmt",
    "LspSymbols",
    "LspAndDiag",
    "NRefPanel",
    "TSymbols",
    "TsAndDiag",
    "Calltree",
  },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
