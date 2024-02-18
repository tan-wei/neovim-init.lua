local M = {
  "mrjones2014/legendary.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  cmd = "Legendary",
}

M.opts = {
  extensions = {
    nvim_tree = true,
    lazy_nvim = true,
    diffview = true,
    which_key = {
      auto_register = false,
      mappings = require("user.keymaps").which_key_mapping,
    },
  },
  lazy_nvim = {
    auto_register = true,
  },
}

return M
