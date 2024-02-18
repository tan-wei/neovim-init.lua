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

M.config = function()
  require("auto-session").setup {
    log_level = vim.log.levels.ERROR,
    auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_session_use_git_branch = true,
    auto_session_enable_last_session = false,
    auto_save_enabled = true,
    auto_session_create_enabled = false,
    session_lens = {
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = true,
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
        if require("util.package").is_loaded "nvim-tree.lua" and require("nvim-tree.view").is_visible() then
          meta.nvimTreeOpen = true
          meta.nvimTreeFocused = vim.fn.bufname(vim.fn.bufnr()) == "NvimTree"
          local api = require "nvim-tree.api"
          if api.tree.winid() then
            api.tree.close_in_this_tab()
          end
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
          if not meta.nvimTreeFocused and vim.api.nvim_win_is_valid(meta.focused) then
            if not winid then
              api.tree.toggle { focus = false, find_file = true }
            else
              api.tree.open()
            end
          end
        end
        ------------------------------------------------
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
      end,
    },
    -- TODO: The problem is: LSP does not stop when switching CWD, and SearchSession works well
    -- cwd_change_handling = {
    --   restore_upcoming_session = true,
    --   pre_cwd_changed_hook = function()
    --     vim.notify "pre_cwd_changed_hook"
    --     vim.lsp.inlay_hint.enable(0, false)
    --     vim.defer_fn(function()
    --       vim.cmd "LspStop"
    --     end, 0)
    --   end,
    --   post_cwd_changed_hook = function()
    --     vim.notify "post_cwd_changed_hook"
    --     require("lualine").refresh()
    --     vim.defer_fn(function()
    --       vim.cmd "filetype detect"
    --     end, 1000)
    --   end,
    -- },
  }

  -- Workaround for nvim-tree, see here: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
  vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter", "TabNewEntered" }, {
    pattern = "NvimTree*",
    callback = function()
      local status_ok, api = pcall(require, "nvim-tree.api")
      if not status_ok then
        return
      end

      local winid = api.tree.winid()
      -- vim.print("winid = " .. tostring(winid))

      if not winid then
        api.tree.open { cureent_window = true }
      end
    end,
  })

  -- Make sure save session, because if nvim-tree is the last buffer, neovim will exit without save session
  vim.api.nvim_create_autocmd({ "QuitPre" }, {
    pattern = "*.*", -- Try to filter out some special buffer
    callback = function()
      local status_ok, auto_session_lib = pcall(require, "auto-session.lib")
      if not status_ok then
        return nil
      end

      -- NOTE: Only if the current session name exist, we should save session
      if pcall(auto_session_lib.current_session_name) then
        vim.cmd ":SessionSave"
      end
    end,
  })

  require("telescope").load_extension "session-lens"
end

return M
