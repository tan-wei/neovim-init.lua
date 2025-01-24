local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000, -- needs to be loaded in first
}

M.config = function()
  require("tiny-inline-diagnostic").setup {
    preset = "modern",
    options = {
      show_source = true,
      use_icons_from_diagnostic = true,
      multiple_diag_under_cursor = true,
      multilines = {
        enabled = true,
        always_show = true,
      },
      enable_on_insert = false,
      enable_on_select = false,
    },
    disabled_ft = {},
  }
  vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
end

return M
