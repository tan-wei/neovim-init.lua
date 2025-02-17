local M = {
  "mawkler/demicolon.nvim",
  enabled = false,
  event = "VeryLazy",
}

-- TODO: Add custom keymaps for other plugins
M.opts = {
  highlight = true,
}

M.opts = {
  diagnostic = {
    float = {},
  },
  keymaps = {
    horizontal_motions = false,
    diagnostic_motions = true,
    repeat_motions = false,
    list_motions = true,
    spell_motions = true,
    fold_motions = true,
  },
  integrations = {
    gitsigns = {
      enabled = true,
      keymaps = {
        next = "]c",
        prev = "[c",
      },
    },
    neotest = {
      enabled = true,
      keymaps = {
        test = {
          next = "]t",
          prev = "[t",
        },
        failed_test = {
          next = "]T",
          prev = "[T",
        },
      },
    },
    vimtex = {
      enabled = false,
    },
  },
}

return M
