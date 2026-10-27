---@type LazyPluginSpec
local M = {
  "https://git.sr.ht/~barrettruth/diffs.nvim",
  lazy = false, -- NOTE: diffs.nvim lazy-loads itself
}

M.init = function()
  vim.g.diffs = {
    integrations = {
      fugitive = true,
      neogit = true,
      neojj = false,
      gitsigns = true,
    },
    conflict = {
      keymaps = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        none = "c0",
        next = "]x",
        prev = "[x",
      },
    },
  }
end

return M
