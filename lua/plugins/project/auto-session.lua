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
    bypass_save_filetypes = { "alpha", "dashboard" },
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
        if require("util.package").is_loaded "nvim-tree.lua" and require("nvim-tree.api").tree.is_visible() then
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
            local winid = api.tree.winid()
            if not winid then
              api.tree.toggle { focus = false, find_file = true }
            else
              api.tree.open { focus = false }
            end
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
      end,
    },
    cwd_change_handling = true,
    pre_cwd_changed_cmds = function()
      vim.notify "pre_cwd_changed_hook"

      vim.defer_fn(function()
        vim.cmd "LspStop"
      end, 0)
    end,
    post_cwd_changed_cmds = function()
      vim.notify "post_cwd_changed_hook"
      require("lualine").refresh()
      vim.defer_fn(function()
        vim.cmd "filetype detect"
      end, 1000)
    end,
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
  vim.api.nvim_create_autocmd({ "QuitPre", "ExitPre", "VimLeavePre" }, {
    pattern = "*",
    callback = function()
      local status_ok, auto_session = pcall(require, "auto-session")

      if status_ok then
        local auto_session_lib = require "auto-session.lib"
        local session_name = auto_session_lib.current_session_name(true)
        -- NOTE: Only if the current session name exist, we should save session
        if session_name ~= "" then
          -- vim.cmd ":SessionSave"

          auto_session.SaveSession()
        end
      end
    end,
  })

  require("telescope").load_extension "session-lens"
end

return M
