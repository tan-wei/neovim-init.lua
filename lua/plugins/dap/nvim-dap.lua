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

M.keys = {
  {
    "<F5>",
    function()
      require("dap").continue()
    end,
    desc = "Debug: Continue",
  },
  {
    "<F17>",
    function()
      require("dap").terminate()
    end,
    desc = "Debug: Terminate",
  },
  {
    "<F10>",
    function()
      require("dap").step_over()
    end,
    desc = "Debug: Step over",
  },
  {
    "<F11>",
    function()
      require("dap").step_into()
    end,
    desc = "Debug: Step into",
  },
  {
    "<F23>", -- Shift + <F11>
    function()
      require("dap").step_out()
    end,
    desc = "Debug: Step out",
  },
  {
    "<F9>",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Debug: Toggle breakpoint",
  },

  {
    "<leader>dp",
    function()
      local condition = vim.fn.input "Breakpoint condition: "
      if condition == "" then
        return
      end
      require("dap").set_breakpoint(condition)
    end,
    desc = "Set condition breakpoint",
  },
  {
    "<leader>dP",
    function()
      local message = vim.fn.input "Log point message: "
      if message == "" then
        return
      end
      require("dap").set_breakpoint(nil, nil, message)
    end,
    desc = "Set log point",
  },
  {
    "<leader>dR",
    function()
      require("dap").repl.toggle()
    end,
    desc = "Toggle REPL",
  },
  {
    "<leader>dl",
    function()
      require("dap").run_last()
    end,
    desc = "Run last",
  },
}

return M
