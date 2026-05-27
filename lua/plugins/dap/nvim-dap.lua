---@type LazyPluginSpec
local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
  },
  lazy = true,
}

-- TODO: This plugin should write more configurations
M.config = function()
  local dap = require "dap"

  dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" },
  }
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "gdb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      -- program = "${fileBasenameNoExtension}",
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
      -- preLaunchTask = "C++ build single file",
    },
  }

  local dapui = require "dapui"
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
end

M.keys = require("user.keymap.registry").lazy_keys "nvim-dap"

return M
