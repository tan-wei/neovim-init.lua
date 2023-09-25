local M = {
  "tversteeg/registers.nvim",
  keys = {
    { '"', mode = { "n", "v" } },
    { "<C-R>", mode = "i" },
  },
  cmd = "Registers",
}

M.init = function() end

return M