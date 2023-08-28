local status_ok, auto_session = pcall(require, "auto-session")
if not status_ok then
  return
end

auto_session.setup {
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
      if not status_ok then
        return
      end
      api.tree.close()
    end,
  },

  post_save_cmds = {
    function()
      local status_ok, api = pcall(require, "nvim-tree.api")
      if not status_ok then
        return
      end
      api.tree.toggle { focus = false, find_file = true }
    end,
  },

  post_restore_cmds = {
    function()
      local status_ok, api = pcall(require, "nvim-tree.api")
      if not status_ok then
        return
      end
      api.tree.toggle { focus = false, find_file = true }
    end,
  },
}

-- Workaround for nvim-tree, see here: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "NvimTree*",
  callback = function()
    local status_ok, api = pcall(require, "nvim-tree.api")
    if not status_ok then
      return
    end

    local status_ok, view = pcall(require, "nvim-tree.view")
    if not status_ok then
      return
    end

    if not view.is_visible() then
      api.tree.open()
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

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "session-lens"
