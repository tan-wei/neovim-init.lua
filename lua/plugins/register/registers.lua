local M = {
  "tversteeg/registers.nvim",
  keys = {
    { '"', mode = { "n", "v" } },
    { "<C-R>", mode = "i" },
  },
  cmd = "Registers",
}

-- TODO: This plugin should write more configurations
M.opts = {}

return M
