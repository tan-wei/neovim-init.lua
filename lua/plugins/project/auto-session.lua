local M = {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  -- event = "VimEnter",
}

local meta = {
  focused = vim.api.nvim_get_current_win(),
  nvimTreeOpen = false,
  nvimTreeFocused = false,
}

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
  require("auto-session").setup {
    log_level = vim.log.levels.ERROR,
    root_dir = vim.fn.stdpath "data" .. "/sessions/",
    suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    git_use_branch_name = true,
    enable_last_session = false,
    auto_save = true,
    auto_create = false,
    session_lens = {
      load_on_setup = true,
      picker_opts = { border = true },
      previewer = true,
    },
    bypass_save_filetypes = { "alpha", "dashboard", "oil", "telescope" },
    save_extra_cmds = {
      save_early_retirement_pins,
    },
    pre_save_cmds = {
      function()
        -- local status_ok, api = pcall(require, "nvim-tree.api")
        -- if status_ok then
        --   local winid = api.tree.winid()

        --   if winid then
        --     api.tree.close_in_this_tab()
        --   end
        -- end

        -- local status_ok, _ = pcall(require, "scope")
        -- if status_ok then
        --   vim.cmd [[ScopeSaveState]]
        -- end

        ------------------------------------------------
        -- ref: https://github.com/b0o/nvim-conf/blob/3f9c92550f79921326a453f3140be9dcf843eb3d/lua/user/fn.lua#L352
        meta.nvimTreeOpen = false
        meta.nvimTreeFocused = false
        if require("util.package").is_loaded "nvim-tree.lua" then
          local api = require "nvim-tree.api"
          -- Check current tab for focus tracking
          if api.tree.is_visible() then
            meta.nvimTreeOpen = true
            meta.nvimTreeFocused = vim.fn.bufname(vim.fn.bufnr()) == "NvimTree"
            meta.focused = vim.api.nvim_get_current_win()
          end
          -- Close nvim-tree in ALL tabs to prevent it from leaking into the session file
          api.tree.close_in_all_tabs()
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
        -- local status_ok, api = pcall(require, "nvim-tree.api")
        -- if status_ok then
        --   local winid = api.tree.winid()

        --   if not winid then
        --     api.tree.toggle { focus = false, find_file = true }
        --   end
        -- end

        ------------------------------------------------
        -- ref: https://github.com/b0o/nvim-conf/blob/3f9c92550f79921326a453f3140be9dcf843eb3d/lua/user/fn.lua#L352
        require("treesitter-context").enable()

        if meta.nvimTreeOpen then
          local api = require "nvim-tree.api"
          local winid = api.tree.winid()
          if not winid then
            api.tree.toggle { focus = false, find_file = true }
          end
          -- Restore focus to the previously focused window (not nvim-tree)
          if not meta.nvimTreeFocused and vim.api.nvim_win_is_valid(meta.focused) then
            vim.api.nvim_set_current_win(meta.focused)
          end
        end
        ------------------------------------------------
      end,
    },
    pre_restore_cmds = {
      function()
        -- NOTE: Ensure dropbar.nvim is launched, similar issue: https://github.com/rmagatti/auto-session/issues/353
        require "dropbar"
      end,
    },
    post_restore_cmds = {
      function()
        local status_ok, _ = pcall(require, "scope")
        if status_ok then
          vim.cmd [[ScopeLoadState]]
        end

        local status_ok, api = pcall(require, "nvim-tree.api")
        if status_ok then
          local winid = api.tree.winid()

          if not winid then
            api.tree.toggle { focus = false, find_file = true }
          end
        end

        if require("util.package").is_loaded "cmake-tools.nvim" then
          vim.notify("Change CWD to " .. vim.fn.getcwd() .. " for cmake-tools.nvim")
          local cmake_tools = require "cmake-tools"
          cmake_tools.select_cwd(vim.fn.getcwd())
          require("lualine").refresh()
        end

        require("treesitter-context").enable()

        local session_name = require("auto-session.lib").current_session_name(true)

        vim.opt.titlestring = "Neovim @ [session: " .. session_name .. "]"
      end,
    },
    cwd_change_handling = true,
    pre_cwd_changed_cmds = {
      function()
        vim.notify "pre_cwd_changed_hook"

        -- Close nvim-tree before cwd change to avoid stale directory state
        local ok, api = pcall(require, "nvim-tree.api")
        if ok then
          api.tree.close_in_all_tabs()
        end

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
        vim.notify "post_cwd_changed_hook"
        require("lualine").refresh()
        vim.defer_fn(function()
          vim.cmd "filetype detect"
        end, 1000)

        vim.cmd "Winsep enable"

        -- Re-open nvim-tree in new cwd (use open, not toggle —
        -- post_restore_cmds may have already opened it, and toggle would close it again)
        local ok, api = pcall(require, "nvim-tree.api")
        if ok and not api.tree.is_visible() then
          api.tree.open { focus = false, find_file = true }
        end
      end,
    },
  }

  -- Workaround for nvim-tree, see here: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
  vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter", "TabNewEntered" }, {
    pattern = "NvimTree*",
    callback = function()
      local status_ok, api = pcall(require, "nvim-tree.api")
      if not status_ok then
        return
      end

      -- Don't force-open if we're the last normal window (about to quit)
      local normal_wins = vim.tbl_filter(function(w)
        return vim.api.nvim_win_get_config(w).relative == ""
          and not vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)):match "NvimTree_"
      end, vim.api.nvim_list_wins())
      if #normal_wins == 0 then
        return
      end

      local winid = api.tree.winid()

      if not winid then
        api.tree.open { current_window = true }
      end
    end,
  })

  require("telescope").load_extension "session-lens"
end

return M
