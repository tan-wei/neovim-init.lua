local M = {
  "dstein64/nvim-scrollview",
  event = "VeryLazy",
}

M.config = function()
  require("scrollview").setup {
    excluded_filetypes = {},
    current_only = true,
    signs_on_startup = {
      "changelist",
      "conflicts",
      -- "cursor", -- NOTE: Quite slow
      "diagnostics",
      "folds",
      "latestchange",
      "loclist",
      "marks",
      "quickfix",
      "search",
      -- "spell",
      -- "textwidth",
      -- "trail",
    },
    diagnostics_severities = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
    },
    mode = "proper",
  }

  require("scrollview.contrib.gitsigns").setup {
    add_priority = 100,
    change_priority = 100,
    delete_priority = 100,
  }
end

return M
