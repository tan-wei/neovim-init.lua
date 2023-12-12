local M = {
  "dstein64/nvim-scrollview",
  event = "VeryLazy",
}

M.config = function()
  require("scrollview").setup {
    excluded_filetypes = {},
    current_only = true,
    signs_on_startup = { "all" },
    diagnostics_severities = { vim.diagnostic.severity.ERROR },
  }

  require("scrollview.contrib.gitsigns").setup {
    add_priority = 100,
    change_priority = 100,
    delete_priority = 100,
  }
end

return M
