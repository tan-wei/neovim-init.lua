local M = {
  "ibhagwan/fzf-lua",
  enabled = function()
    if vim.uv.os_uname().sysname ~= "Windows_NT" then
      return true
    else
      return false
    end
  end,
  dependencies = {
    {
      "junegunn/fzf",
      build = function()
        if vim.uv.os_uname().sysname == "Windows_NT" then
          local job = require "plenary.job"
          job
            :new({
              command = "powershell",
              args = { "-File", "./install.ps1", "--bin" },
              cwd = vim.fn.stdpath "data" .. "/lazy/fzf",
            })
            :sync()
        else
          return "./install --bin"
        end
      end,
    },
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "FzfLua",
}

M.config = true

return M
