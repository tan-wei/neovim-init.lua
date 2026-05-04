local M = {
  "klen/nvim-config-local",
  config = function()
    local config_local = require "config-local"
    local config_files = {
      ".nvim.lua",
      ".nvimrc",
      ".exrc",
      ".nvim/nvim.lua",
    }

    config_local.setup {
      config_files = config_files,
      hashfile = vim.fn.stdpath "data" .. "/config-local",
      autocommands_create = false,
      commands_create = true,
      silent = false,
      lookup_parents = true,
    }

    config_local.source()

    local augroup = vim.api.nvim_create_augroup("config-local-local", { clear = true })

    vim.api.nvim_create_autocmd("DirChanged", {
      group = augroup,
      desc = "Source local configs",
      callback = config_local.source,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      desc = "Confirm local configs",
      pattern = vim.tbl_map(function(file)
        return "**/" .. file
      end, config_files),
      nested = true,
      callback = config_local.confirm,
    })
  end,
  event = { "VimEnter" },
}

return M
