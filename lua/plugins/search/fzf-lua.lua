local M = {
  "ibhagwan/fzf-lua",
  enabled = require("util.package").enabled_unix_only(),
  dependencies = {
    {
      "junegunn/fzf",
      build = "./install --bin",
    },
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "FzfLua",
}

M.config = true

return M
