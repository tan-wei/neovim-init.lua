-- STATUS: [TEMPORARILY DISABLED] Incompatible with nvim-treesitter main branch.
-- The plugin internally requires 'nvim-treesitter.query' which was removed in the main branch rewrite.
-- Re-enable once the plugin is updated for the new API.
-- Tracks: https://github.com/RRethy/nvim-treesitter-textsubjects
--
-- Lost features (until re-enabled):
--   - '.'  textsubjects-smart           (select smart syntactical region)
--   - ';'  textsubjects-container-outer  (select outer container)
--   - 'i;' textsubjects-container-inner  (select inner container)
--   - ','  repeat previous selection
local M = {
  "RRethy/nvim-treesitter-textsubjects",
  enabled = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.config = function()
  require("nvim-treesitter-textsubjects").configure {
    prev_selection = ",",
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  }
end

return M
