---@type LazyPluginSpec
local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mxsdev/nvim-dap-vscode-js",
    "jbyuki/one-small-step-for-vimkind",
    "suketa/nvim-dap-ruby",
    { "tomblind/local-lua-debugger-vscode", build = "npm ci --legacy-peer-deps && npm run build" },
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
  dap.adapters.python = {
    type = "executable",
    command = "debugpy-adapter",
  }
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }
  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }
  require("dap-vscode-js").setup {
    debugger_cmd = { "js-debug-adapter" },
    adapters = { "pwa-node" },
  }
  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end
  dap.adapters["lua-local"] = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath "data" .. "/lazy/local-lua-debugger-vscode/extension/debugAdapter.js" },
    enrich_config = function(config, on_config)
      config.extensionPath = vim.fn.stdpath "data" .. "/lazy/local-lua-debugger-vscode"
      on_config(config)
    end,
  }
  dap.adapters.bash = function(callback, config)
    local bashdb = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "opt", "bashdb")
    config.pathBashdb = vim.fs.joinpath(bashdb, "bashdb")
    config.pathBashdbLib = bashdb
    callback { type = "executable", command = "bash-debug-adapter" }
  end
  require("dap-ruby").setup()
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
      stopAtBeginningOfMainSubprogram = true,
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
