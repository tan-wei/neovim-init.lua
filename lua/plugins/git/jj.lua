---@type LazyPluginSpec
local M = {
  "NicolasGB/jj.nvim",
  cmd = {
    "J",
    "Jdiff",
    "Jvdiff",
    "Jhdiff",
    "Jread",
    "Jedit",
    "Jtabedit",
    "Jsplit",
    "Jvsplit",
    "Jbrowse",
  },
}

M.opts = {
  editor = { auto_insert = true },
  diff = { backend = "native" },
  cmd = { confirm_destructive_actions = true },
}

return M
