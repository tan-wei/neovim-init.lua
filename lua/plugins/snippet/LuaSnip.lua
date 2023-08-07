local M = {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  build = function()
    if vim.uv.os_uname().sysname ~= "Windows_NT" then
      local job = require "plenary.job"
      job
        :new({
          command = "make",
          args = { "install_jsregexp" },
          cwd = vim.fn.stdpath "data" .. "/lazy/LuaSnip",
        })
        :sync()
    end
  end,
}

M.init = function() end

return M
