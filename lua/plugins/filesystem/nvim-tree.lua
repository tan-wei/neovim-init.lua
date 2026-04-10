local M = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "b0o/nvim-tree-preview.lua",
  },
  event = "VimEnter",
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

M.config = function()
  local nvim_tree = require "nvim-tree"
  local nvim_tree_api = require "nvim-tree.api"
  local preview = require "nvim-tree-preview"
  local nvim_tree_open = {}

  -- Smart buffer close: Bdelete, then close tab/quit if nothing real remains
  vim.api.nvim_create_user_command("BdeleteOrClose", function(opts)
    local bufnr = opts.args ~= "" and tonumber(opts.args) or 0
    local ok, _ = pcall(vim.cmd, "Bdelete! " .. (bufnr ~= 0 and bufnr or ""))
    if not ok then
      return
    end
    -- After Bdelete, check if any real file buffer remains in this tab
    local has_real = false
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(w).relative == "" then
        local buf = vim.api.nvim_win_get_buf(w)
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" and not name:match "NvimTree_" then
          has_real = true
          break
        end
      end
    end
    if not has_real then
      if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd "tabclose"
      else
        vim.cmd "qa"
      end
    end
  end, { nargs = "?" })

  nvim_tree_api.events.subscribe(nvim_tree_api.events.Event.TreeOpen, function()
    local winid = nvim_tree_api.tree.winid { tabpage = 0 }
    nvim_tree_open[winid] = true
  end)
  nvim_tree_api.events.subscribe(nvim_tree_api.events.Event.TreeClose, function()
    local winid = nvim_tree_api.tree.winid { tabpage = 0 }
    local tabpage = vim.api.nvim_get_current_tabpage()
  end)

  -- Open on startup
  vim.api.nvim_create_autocmd({ "VimEnter", "TabNew", "TabNewEntered", "TabEnter" }, {
    callback = function(data)
      local winid = nvim_tree_api.tree.winid { tabpage = 0 }
      if nvim_tree_open[winid] then
        return
      end
      -- buffer is a real file on the disk
      local real_file = vim.fn.filereadable(data.file) == 1

      -- buffer is a [No Name]
      local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

      if not real_file and not no_name then
        return
      end

      -- open the tree, find the file but don't focus it
      nvim_tree_api.tree.toggle { focus = false, find_file = true }
    end,
  })

  -- Auto close: when :q on the last real window, close everything so Neovim exits
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      local normal_wins = {}
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(w)
          and vim.api.nvim_win_get_config(w).relative == ""
          and not vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)):match "NvimTree_"
        then
          table.insert(normal_wins, w)
        end
      end
      -- Current window is about to be :q'd; if it's the only normal one,
      -- close all other windows (nvim-tree, other tabs) so :q exits Neovim.
      if #normal_wins == 1 then
        -- Save session with all tabs intact before we close anything
        local as_ok, auto_session = pcall(require, "auto-session")
        if as_ok then
          auto_session.auto_save_session()
          -- Prevent VimLeavePre from overwriting with a single-tab session
          require("auto-session.config").enabled = false
        end

        local curwin = vim.api.nvim_get_current_win()
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if w ~= curwin and vim.api.nvim_win_is_valid(w) then
            local ok, cfg = pcall(vim.api.nvim_win_get_config, w)
            if ok and cfg.relative == "" then
              pcall(vim.api.nvim_win_close, w, true)
            end
          end
        end
      end
    end,
  })

  -- QuickFixDecorator
  -- Credit: https://github.com/b0o/dotfiles/blob/ae8391421e025fb22dacad47eb1bb954b04bfa40/config/nvim/lua/user/plugins/nvim-tree/decorator-quickfix.lua
  local QuickfixDecorator = require("nvim-tree.api").decorator.UserDecorator:extend()

  local augroup = vim.api.nvim_create_augroup("nvim-tree-decorator-quickfix", { clear = true })

  local autocmds_setup = false
  local function setup_autocmds()
    if autocmds_setup then
      return
    end
    autocmds_setup = true
    vim.api.nvim_create_autocmd("QuickfixCmdPost", {
      group = augroup,
      callback = function()
        require("nvim-tree.api").tree.reload()
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      group = augroup,
      callback = function(evt)
        vim.api.nvim_create_autocmd("TextChanged", {
          buffer = evt.buf,
          group = augroup,
          callback = function()
            require("nvim-tree.api").tree.reload()
          end,
        })
      end,
    })
  end

  function QuickfixDecorator:new()
    self.enabled = true
    self.highlight_range = "none"
    self.icon_placement = "signcolumn"
    self.qf_icon = { str = "", hl = { "QuickFixLine" } }
    self:define_sign(self.qf_icon)
    setup_autocmds()
  end

  local function is_qf_item(node)
    if node.name == ".." or node.type == "directory" then
      return false
    end
    local bufnr = vim.fn.bufnr(node.absolute_path)
    return bufnr ~= -1 and vim.iter(vim.fn.getqflist()):any(function(qf)
      return qf.bufnr == bufnr
    end)
  end

  function QuickfixDecorator:icons(node)
    if is_qf_item(node) then
      return { self.qf_icon }
    end
    return nil
  end

  function QuickfixDecorator:highlight_group(node)
    if is_qf_item(node) then
      return "QuickFixLine"
    end
    return nil
  end

  nvim_tree.setup {
    sync_root_with_cwd = true,
    respect_buf_cwd = false,
    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = { "/tmp" },
    },
    renderer = {
      root_folder_modifier = ":t",
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
      decorators = {
        "Git",
        "Open",
        "Hidden",
        "Modified",
        "Bookmark",
        "Diagnostics",
        QuickfixDecorator,
        "Copied",
        "Cut",
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    filters = {
      git_ignored = false,
    },
    git = {
      timeout = 5000,
    },
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"

      api.config.mappings.default_on_attach(bufnr)

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      vim.keymap.set("n", "P", preview.watch, opts "Preview (Watch)")
      vim.keymap.set("n", "<Esc>", preview.unwatch, opts "Close Preview/Unwatch")
      vim.keymap.set("n", "<C-f>", function()
        return preview.scroll(4)
      end, opts "Scroll Down")
      vim.keymap.set("n", "<C-b>", function()
        return preview.scroll(-4)
      end, opts "Scroll Up")

      -- Smart tab behavior: Only preview files, expand/collapse directories (recommended)
      vim.keymap.set("n", "<Tab>", function()
        local ok, node = pcall(api.tree.get_node_under_cursor)
        if ok and node then
          if node.type == "directory" then
            api.node.open.edit()
          else
            preview.node(node, { toggle_focus = true })
          end
        end
      end, opts "Preview")
    end,
  }
end

return M
