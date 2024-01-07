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
  enabled = false, -- TODO: Now disable it, we should configure for it firstly
}

-- TODO: This plugin should write more configurations
M.config = true

return M
