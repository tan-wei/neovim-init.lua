---@type LazyPluginSpec
local M = {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
}

M.config = function()
  require("smoothcursor").setup {
    fancy = {
      enable = true,
    },
    disabled_filetypes = {
      "lazy",
      "NvimTree",
      "qf",
      "help",
      "Outline",
      "toggleterm",
      "alpha",
      "mason",
      "checkhealth",
      "noice",
      "notify",
      "fugitive",
      "neogit",
      "undotree",
      "trouble",
      "TelescopePrompt",
      "TelescopeResults",
      "dapui_breakpoint",
      "dapui_stacks",
      "dapui_scopes",
      "dapui_console",
      "dapui_watches",
    },
    disable_float_win = true,
  }
end

return M
