local M = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "b0o/nvim-tree-preview.lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "3rd/image.nvim",
    },
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
  local nvim_tree_open = {}

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

  -- Auto close
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      local tree_wins = {}
      local floating_wins = {}
      local wins = vim.api.nvim_list_wins()
      for _, w in ipairs(wins) do
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
        if bufname:match "NvimTree_" ~= nil then
          table.insert(tree_wins, w)
        end
        if vim.api.nvim_win_get_config(w).relative ~= "" then
          table.insert(floating_wins, w)
        end
      end
      if 1 == #wins - #floating_wins - #tree_wins then
        -- Should quit, so we close all invalid windows.
        for _, w in ipairs(tree_wins) do
          vim.api.nvim_win_close(w, true)
        end
      end
    end,
  })

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
      timeout = 2000,
    },
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"

      api.config.mappings.default_on_attach(bufnr)

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local preview = require "nvim-tree-preview"

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
