local M = {
  "s1n7ax/nvim-window-picker",
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.config = function()
  require("window-picker").setup {
    filter_rules = {
      bo = {
        filetype = { "smear-cursor" },
      },
    },
  }
end

return M
