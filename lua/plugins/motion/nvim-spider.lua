---@type LazyPluginSpec
local M = {
  "chrisgrieser/nvim-spider",
  lazy = true,
}

M.opts = {
  skipInsignificantPunctuation = true,
  subwordMovement = true,
  consistentOperatorPending = false,
}

M.keys = {
  {
    "<A-w>",
    "<cmd>lua require('spider').motion('w')<CR>",
    mode = { "n", "o", "x" },
    desc = "Spider motion: w",
  },
  {
    "<A-e>",
    "<cmd>lua require('spider').motion('e')<CR>",
    mode = { "n", "o", "x" },
    desc = "Spider motion: e",
  },
  {
    "<A-b>",
    "<cmd>lua require('spider').motion('b')<CR>",
    mode = { "n", "o", "x" },
    desc = "Spider motion: b",
  },
}

return M
