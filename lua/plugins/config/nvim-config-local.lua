---@type LazyPluginSpec
local M = {
  "klen/nvim-config-local",
  lazy = false,
  priority = 1000,
  config = function()
    local config_local = require "config-local"
    local hash_map = require "config-local.hashmap"
    local config_files = {
      ".nvim/nvim.lua",
      ".nvim.lua",
      ".nvimrc",
      ".exrc",
    }
    local hashfile = vim.fn.stdpath "data" .. "/config-local"
    local default_config = table.concat({
      "-- Project-local Neovim config.",
      "-- This file is loaded by nvim-config-local after you trust it with :ConfigLocalTrust.",
      "-- Fill TODO fields for this repository. Other values below match the repo defaults.",
      "",
      'vim.g.header_field_project = "TODO: Project Name"',
      'vim.g.templates_guard_prefix = "TODO: Template Guard Prefix"',
      'vim.g.header_field_author = "TODO: Author Name"',
      'vim.g.header_field_author_email = "TODO: Author Email"',
      "vim.g.header_auto_add_header = 0",
      "vim.g.header_auto_update_header = 1",
      "vim.g.header_field_filename = 1",
      "vim.g.header_field_timestamp = 1",
      'vim.g.header_field_timestamp_format = "%Y-%m-%d %H:%M:%S"',
      "vim.g.header_field_modified_by = 1",
      "vim.g.header_alignment = 1",
      "",
      "vim.g.disable_autoformat = false",
      "vim.g.restore_overseer_tasks = false",
      "",
      "vim.g.linters = {",
      "  clangtidy = false,",
      "  cppcheck = false,",
      "  cpplint = false,",
      "  dotenv_linter = true,",
      "}",
      "",
      'vim.g.vimtex_view_method = "zathura"',
      "",
      'vim.g.bullets_enabled_file_types = { "markdown" }',
      "vim.g.bullets_line_spacing = 1",
      "vim.g.bullets_pad_right = 0",
      "vim.g.bullets_checkbox_partials_toggle = 1",
      'vim.g.bullets_checkbox_markers = " .oOX"',
      "vim.g.bullets_delete_last_bullet_if_empty = 1",
      "vim.g.bullets_auto_indent_after_colon = 1",
      'vim.g.bullets_outline_levels = { "std-", "std*", "std+" }',
      "",
      "vim.g.vmt_auto_update_on_save = 1",
      "vim.g.vmt_dont_insert_fence = 0",
      "vim.g.vmt_cycle_list_item_markers = 1",
      'vim.g.vmt_list_item_chars = { "*", "-", "+" }',
      "",
      'vim.g.table_mode_corner = "|"',
      "",
    }, "\n")

    local function config_path(filename)
      return vim.fs.joinpath(vim.fn.getcwd(), filename)
    end

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

    local function create_project_config()
      local filename = config_local.lookup and config_local.lookup() or nil
      if filename then
        vim.notify("Project config already exists: " .. vim.fn.fnamemodify(filename, ":~:."), vim.log.levels.INFO)
        vim.cmd.edit(vim.fn.fnameescape(filename))
        return
      end

      filename = config_path(config_files[1])
      vim.fn.mkdir(vim.fn.fnamemodify(filename, ":h"), "p")

      vim.cmd.edit(vim.fn.fnameescape(filename))
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(default_config, "\n", { plain = true }))
      vim.bo.modified = true
      vim.notify(
        "Prepared unsaved project config: "
          .. vim.fn.fnamemodify(filename, ":~:.")
          .. " (update TODO fields, then :write)",
        vim.log.levels.INFO
      )
      refresh_project_config_status()
    end

    config_local.setup {
      config_files = config_files,
      hashfile = hashfile,
      autocommands_create = false,
      commands_create = true,
      silent = true,
      lookup_parents = true,
    }

    pcall(vim.api.nvim_del_user_command, "ConfigLocalCreate")
    vim.api.nvim_create_user_command("ConfigLocalCreate", create_project_config, {
      desc = "Prepare an unsaved project-local Neovim config",
    })

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
