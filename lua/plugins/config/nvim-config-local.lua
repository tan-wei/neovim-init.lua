local M = {
  "klen/nvim-config-local",
  config = function()
    require("config-local").setup {
      config_files = {
        ".nvim.lua",
        ".nvimrc",
        ".exrc",
        ".nvim/nvim.lua",
      },
      hashfile = vim.fn.stdpath "data" .. "/config-local",
      autocommands_create = true,
      commands_create = true,
      silent = false,
      lookup_parents = false,
    }
  end,
  event = { "VimEnter" },
}

return M
