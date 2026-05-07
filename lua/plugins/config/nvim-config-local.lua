local M = {
  "klen/nvim-config-local",
  lazy = false,
  priority = 1000,
  config = function()
    local config_local = require "config-local"
    local hash_map = require "config-local.hashmap"
    local config_files = {
      ".nvim.lua",
      ".nvimrc",
      ".exrc",
      ".nvim/nvim.lua",
    }
    local hashfile = vim.fn.stdpath "data" .. "/config-local"

    local function refresh_project_config_status()
      local filename = config_local.lookup and config_local.lookup() or nil
      if not filename then
        vim.g.project_config_local_active = false
        vim.g.project_config_local_file = nil
        vim.g.project_config_local_state = nil
      else
        local state = hash_map:init(hashfile):verify(filename)
        vim.g.project_config_local_active = state == "t"
        vim.g.project_config_local_file = filename
        vim.g.project_config_local_state = state
      end

      pcall(function()
        require("lualine").refresh { place = { "statusline" } }
      end)
    end

    config_local.setup {
      config_files = config_files,
      hashfile = hashfile,
      autocommands_create = false,
      commands_create = true,
      silent = true,
      lookup_parents = true,
    }

    local augroup = vim.api.nvim_create_augroup("config-local-local", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = "ConfigLocalFinished",
      callback = refresh_project_config_status,
    })

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
      callback = function()
        config_local.confirm()
        refresh_project_config_status()
      end,
    })

    config_local.source()
  end,
}

return M
