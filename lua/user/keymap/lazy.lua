local builtin = require "user.keymap.builtin"

local function peek_fold_or_hover()
  local ufo = require "ufo"
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover { border = "rounded" }
  end
end

local function cmd(command)
  return table.concat { "<Cmd>", command, "<CR>" }
end

---@type table<string, UserKeymapGroup[]>
return {
  ["nvim-dap"] = {
    {
      plugin = "nvim-dap",
      family = "plain",
      maps = {
        {
          mode = "n",
          lhs = "<F6>",
          rhs = function()
            require("dap").continue()
          end,
          desc = "Debug: Continue",
        },
        {
          mode = "n",
          lhs = "<F17>",
          rhs = function()
            require("dap").terminate()
          end,
          desc = "Debug: Terminate",
        },
        {
          mode = "n",
          lhs = "<F10>",
          rhs = function()
            require("dap").step_over()
          end,
          desc = "Debug: Step over",
        },
        {
          mode = "n",
          lhs = "<F11>",
          rhs = function()
            require("dap").step_into()
          end,
          desc = "Debug: Step into",
        },
        {
          mode = "n",
          lhs = "<F23>",
          rhs = function()
            require("dap").step_out()
          end,
          desc = "Debug: Step out",
        },
        {
          mode = "n",
          lhs = "<F9>",
          rhs = function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Debug: Toggle breakpoint",
        },
        {
          mode = "n",
          lhs = "<leader>dp",
          rhs = function()
            local condition = vim.fn.input "Breakpoint condition: "
            if condition == "" then
              return
            end
            require("dap").set_breakpoint(condition)
          end,
          desc = "Set condition breakpoint",
        },
        {
          mode = "n",
          lhs = "<leader>dP",
          rhs = function()
            local message = vim.fn.input "Log point message: "
            if message == "" then
              return
            end
            require("dap").set_breakpoint(nil, nil, message)
          end,
          desc = "Set log point",
        },
        {
          mode = "n",
          lhs = "<leader>dR",
          rhs = function()
            require("dap").repl.toggle()
          end,
          desc = "Toggle REPL",
        },
        {
          mode = "n",
          lhs = "<leader>dl",
          rhs = function()
            require("dap").run_last()
          end,
          desc = "Run last",
        },
      },
    },
  },
  ["nvim-ufo"] = {
    {
      plugin = "nvim-ufo",
      family = "z",
      maps = {
        {
          mode = "n",
          lhs = "zR",
          rhs = function()
            require("ufo").openAllFolds()
          end,
          desc = "UFO: Open all folds",
          conflict = { builtin = builtin.get("n", "zR") },
        },
        {
          mode = "n",
          lhs = "zM",
          rhs = function()
            require("ufo").closeAllFolds()
          end,
          desc = "UFO: Close all folds",
          conflict = { builtin = builtin.get("n", "zM") },
        },
        {
          mode = "n",
          lhs = "zr",
          rhs = function()
            require("ufo").openFoldsExceptKinds()
          end,
          desc = "UFO: Open folds except kinds",
          conflict = { builtin = builtin.get("n", "zr") },
        },
        {
          mode = "n",
          lhs = "zm",
          rhs = function()
            require("ufo").closeFoldsWith()
          end,
          desc = "UFO: Close folds with level",
          conflict = { builtin = builtin.get("n", "zm") },
        },
        {
          mode = "n",
          lhs = "K",
          rhs = peek_fold_or_hover,
          desc = "UFO: Peek folded lines or hover",
          conflict = {
            builtin = builtin.get("n", "K"),
            note = "Shadowed by the LSP buffer-local K after attach",
          },
        },
      },
    },
  },
  ["windows.nvim"] = {
    {
      plugin = "windows.nvim",
      family = "plain",
      maps = {
        {
          mode = "n",
          lhs = "<C-w>z",
          rhs = cmd "WindowsMaximize",
          desc = "Windows: Maximize",
          conflict = { builtin = builtin.get("n", "<C-w>z") },
        },
        {
          mode = "n",
          lhs = "<C-w>_",
          rhs = cmd "WindowsMaximizeVertically",
          desc = "Windows: Maximize vertically",
          conflict = { builtin = builtin.get("n", "<C-w>_") },
        },
        {
          mode = "n",
          lhs = "<C-w>|",
          rhs = cmd "WindowsMaximizeHorizontally",
          desc = "Windows: Maximize horizontally",
          conflict = { builtin = builtin.get("n", "<C-w>|") },
        },
        {
          mode = "n",
          lhs = "<C-w>=",
          rhs = cmd "WindowsEqualize",
          desc = "Windows: Equalize",
          conflict = { builtin = builtin.get("n", "<C-w>=") },
        },
      },
    },
  },
}
