local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  -- vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts "Up")
  -- vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
end

-- Open on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    if not real_file and not no_name then
      return
    end

    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle { focus = false, find_file = true }
  end,
})

-- Auto close
local function tab_win_closed(winnr)
  local api = require "nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w)
    return w ~= winnr
  end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match ".*NvimTree_%d*$" then -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else -- else closed buffer was normal buffer
    if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match ".*NvimTree_%d*$" then -- and that buffer is nvim tree
        vim.schedule(function()
          if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
            vim.cmd "quit" -- then close all of vim
          else -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    local winnr = tonumber(vim.fn.expand "<amatch>")
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true,
})

nvim_tree.setup {
  -- required for project.nvim to auto change root dir
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
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
  view = {
    width = 30,
    side = "left",
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
  },

  on_attach = on_attach,
}
