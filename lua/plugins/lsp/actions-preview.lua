---@type LazyPluginSpec
local M = {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  require("actions-preview").setup {
    highlight_command = {
      require("actions-preview.highlight").delta "delta --no-gitconfig --side-by-side --line-numbers --paging=always",
      require("actions-preview.highlight").diff_so_fancy(),
      require("actions-preview.highlight").diff_highlight(),
    },
    backend = { "nui" },
  }
end

return M
