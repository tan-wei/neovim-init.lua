-- STATUS: [DEPRECATED] Archived on 2025-11-28, permanently incompatible with nvim-treesitter main branch.
-- Planned replacement: https://github.com/nvim-treesitter/nvim-treesitter-locals (not yet stable as of 2026-04)
--
-- The following features have NO current replacement:
--   - refactor.highlight_definitions  (highlight definition and usages of symbol under cursor)
--   - refactor.highlight_current_scope (highlight block of current scope)
--   - refactor.smart_rename            (rename symbol within current scope, was mapped to 'grr')
--   - refactor.navigation              (goto definition 'gnd', list definitions 'gnD'/'gO',
--                                       goto next/prev usage '<a-*>'/'<a-#>')
local M = {
  "nvim-treesitter/nvim-treesitter-refactor",
  enabled = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

return M
