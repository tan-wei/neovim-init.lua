---@type LazyPluginSpec
local M = {
  "rmagatti/auto-session",
  dependencies = { "nvim-tree/nvim-tree.lua" },
  -- event = "VimEnter",
}

local function should_restore_overseer_tasks()
  return require("util.project_config").get "restore_overseer_tasks" == true
end

local function source_project_local_config()
  if vim.fn.exists ":ConfigLocalSource" > 0 then
    pcall(vim.cmd, "silent ConfigLocalSource")
    return
  end

  local ok, config_local = pcall(require, "config-local")
  if ok then
    pcall(config_local.source)
  end
end

--- Adapted from Overseer's third_party.md auto-session example.
--- Current auto-session persists auxiliary restore commands through
--- save_extra_cmds, which writes to the companion x.vim file.
local function save_overseer_tasks()
  if not should_restore_overseer_tasks() then
    return nil
  end

  local ok, task_list = pcall(require, "overseer.task_list")
  if not ok then
    return nil
  end

  local tasks = task_list.list_tasks { include_ephemeral = false, unique = false }
  if #tasks == 0 then
    return nil
  end

  local cmds = {}
  for _, task in ipairs(tasks) do
    local ok_serialize, serialized = pcall(task.serialize, task)
    if ok_serialize and serialized then
      local ok_json, json = pcall(vim.json.encode, serialized)
      if ok_json and json then
        json = json:gsub("\\/", "/")
        json = json:gsub("'", "\\'")
        table.insert(
          cmds,
          string.format(
            "lua if require('util.project_config').get('restore_overseer_tasks') == true then require('overseer').new_task(vim.json.decode('%s')):start() end",
            json
          )
        )
      end
    end
  end

  if #cmds == 0 then
    return nil
  end

  return cmds
end

local function clear_overseer_tasks()
  local ok, overseer = pcall(require, "overseer")
  if not ok then
    return
  end

  for _, task in ipairs(overseer.list_tasks { include_ephemeral = true, unique = false }) do
    task:dispose(true)
  end
end

local function ensure_plugin_loaded_for_restore(plugin)
  local ok_config, lazy_config = pcall(require, "lazy.core.config")
  if not ok_config then
    return false
  end

  local spec = lazy_config.plugins[plugin]
  if not spec or spec.enabled == false then
    return false
  end

  if spec._.loaded then
    return true
  end

  local ok_lazy, lazy = pcall(require, "lazy")
  if not ok_lazy then
    return false
  end

  lazy.load { plugins = { plugin } }
  return spec._.loaded
end

--- Save pinned buffer state (vim-early-retirement) so it survives session restore.
--- Returns a list of Lua commands that re-pin each buffer by setting b:ignore_early_retirement.
local function save_early_retirement_pins()
  local cmds = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ok, val = pcall(vim.api.nvim_buf_get_var, buf, "ignore_early_retirement")
      if ok and val then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" then
          table.insert(
            cmds,
            string.format("lua vim.api.nvim_buf_set_var(vim.fn.bufnr([[%s]]), 'ignore_early_retirement', true)", name)
          )
        end
      end
    end
  end
  return cmds
end

M.config = function()
  local restore_attempted = false

  require("auto-session").setup {
    log_level = vim.log.levels.ERROR,
    root_dir = vim.fn.stdpath "data" .. "/sessions/",
    suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    git_use_branch_name = true,
    enable_last_session = false,
    auto_save = true,
    auto_create = false,
    session_lens = {
      picker = "fzf",
      previewer = true,
    },
    bypass_save_filetypes = { "alpha", "dashboard", "oil", "fzf", "Outline", "terminal" },
    close_unsupported_windows = {
      preserve_filetypes = { "NvimTree" },
    },
    save_extra_cmds = {
      save_early_retirement_pins,
      save_overseer_tasks,
    },
    pre_save_cmds = {
      function()
        ------------------------------------------------
        -- ref: https://github.com/b0o/nvim-conf/blob/3f9c92550f79921326a453f3140be9dcf843eb3d/lua/user/fn.lua#L352
        -- Close Outline before saving session to prevent exit hang
        if require("util.package").is_loaded "outline.nvim" then
          pcall(vim.cmd, "OutlineClose")
        end

        local status_ok, _ = pcall(require, "scope")
        if status_ok then
          vim.cmd [[ScopeSaveState]]
        end

        require("treesitter-context").disable()
        ------------------------------------------------
      end,
    },
    post_save_cmds = {
      function()
        ------------------------------------------------
        -- ref: https://github.com/b0o/nvim-conf/blob/3f9c92550f79921326a453f3140be9dcf843eb3d/lua/user/fn.lua#L352
        require("treesitter-context").enable()

        -- Refresh winsep separators after session save window changes
        vim.schedule(function()
          pcall(function()
            require("colorful-winsep.view").render()
          end)
        end)
        ------------------------------------------------
      end,
    },
    pre_restore_cmds = {
      function()
        restore_attempted = true
      end,
      source_project_local_config,
      clear_overseer_tasks,
      function()
        -- Session restore replays local winbar options. If a session contains
        -- dropbar's v:lua expression, load the plugin through lazy first.
        ensure_plugin_loaded_for_restore "dropbar.nvim"
      end,
    },
    post_restore_cmds = {
      source_project_local_config,
      function()
        local status_ok, _ = pcall(require, "scope")
        if status_ok then
          vim.cmd [[ScopeLoadState]]
        end

        if require("util.package").is_loaded "cmake-tools.nvim" then
          vim.notify("Change CWD to " .. vim.fn.getcwd() .. " for cmake-tools.nvim")
          require("util.cmake_project").select_root(vim.fn.getcwd())
          require("lualine").refresh()
        end

        require("treesitter-context").enable()

        local session_name = require("auto-session.lib").current_session_name(true)

        vim.opt.titlestring = "Neovim @ [session: " .. session_name .. "]"
      end,
    },
    no_restore_cmds = {
      function(is_startup)
        if is_startup and not restore_attempted and vim.v.this_session == "" and not vim.g.in_pager_mode then
          vim.api.nvim_exec_autocmds("User", { pattern = "AutoSessionNoRestore" })
        end
      end,
    },
    cwd_change_handling = true,
    pre_cwd_changed_cmds = {
      function()
        -- Stop LSP clients synchronously before cwd change.
        -- Using vim.defer_fn causes a race: auto-session wipes buffers before
        -- LSP has fully detached, leading to "Failed to delete autocmd" errors.
        for _, client in ipairs(vim.lsp.get_clients()) do
          client:stop()
        end

        vim.cmd "Winsep disable"
      end,
    },
    post_cwd_changed_cmds = {
      function()
        require("lualine").refresh()
        vim.defer_fn(function()
          vim.cmd "filetype detect"
        end, 1000)

        vim.cmd "Winsep enable"
      end,
    },
  }
end

return M
