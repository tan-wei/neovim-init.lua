local M = {
  "obsidian-nvim/obsidian.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = "markdown",
  enabled = false,
}

M.opts = {
  workspaces = {
    {
      name = "buf-parent",
      path = function()
        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
      end,
    },
    {
      name = "no-vault",
      path = function()
        -- alternatively use the CWD:
        -- return assert(vim.fn.getcwd())
        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
      end,
      overrides = {
        notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
        new_notes_location = "current_dir",
        templates = {
          folder = vim.NIL,
        },
        disable_frontmatter = true,
      },
    },
  },
  ui = {
    enable = false, -- NOTE: Enable it requires conceallevel set 1 or 2
  },
  legacy_commands = false,
}

return M
