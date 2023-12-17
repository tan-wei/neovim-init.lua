local M = {
  "rmagatti/auto-session",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "VimEnter",
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
        local status_ok, api = pcall(require, "nvim-tree.api")
        if status_ok then
          local winid = api.tree.winid()

          if winid then
            api.tree.close_in_this_tab()
          end
        end

        local status_ok, _ = pcall(require, "scope")
        if status_ok then
          vim.cmd [[ScopeSaveState]]
        end
      end,
    },

    post_save_cmds = {
      function()
        local status_ok, api = pcall(require, "nvim-tree.api")
        if status_ok then
          local winid = api.tree.winid()

          if not winid then
            api.tree.toggle { focus = false, find_file = true }
          end
        end
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
      if auto_session_lib.current_session_name() then
        vim.cmd ":SessionSave"
      end
    end,
  })

  require("telescope").load_extension "session-lens"
end

return M
