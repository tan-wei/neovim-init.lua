local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  lazy = true,
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("dapui").setup {
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
      icons = {
        pause = "⏸",
        play = "▶",
        step_into = "⏎",
        step_over = "⏭",
        step_out = "⏮",
        step_back = "b",
        run_last = "▶▶",
        terminate = "⏹",
        disconnect = "⏏",
      },
    },
  }
end

return M
