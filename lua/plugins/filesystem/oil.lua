---@type LazyPluginSpec
local M = {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
}

M.init = function()
  -- disable netrw at the very start of our init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

M.opts = {
  default_file_explorer = false,
  show_hidden_files = true,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  float = {
    padding = 4,
    max_width = 180,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 10,
    },
  },
  constrain_cursor = "editable",
  watch_for_changes = true,
  keymaps = {
    ["q"] = "actions.close",
  },
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, bufnr)
      local m = name:match "^%."
      return m ~= nil
    end,
    is_always_hidden = function(name, bufnr)
      return name == "." or name == ".."
    end,
    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
      return nil
    end,
  },
}

return M
