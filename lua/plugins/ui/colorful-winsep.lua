---@type LazyPluginSpec
local M = {
  "nvim-zh/colorful-winsep.nvim",
  dependencies = {
    "mawkler/modicator.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  border = "rounded",
  highlight = function()
    vim.api.nvim_set_hl(0, "ColorfulWinSep", { link = "CursorLineNr" })
  end,
  excluded_ft = {
    "packer",
    "fzf",
    "mason",
    "NvimTree",
    "alpha",
    "checkhealth",
    "Outline",
    "toggleterm",
    "OverseerList",
    "OverseerForm",
    "qf",
    "help",
    "lazy",
    "noice",
    "notify",
    "trouble",
    "fugitive",
    "neogit",
    "undotree",
    "fzflua_backdrop",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
}

M.config = function(_, opts)
  local winsep = require "colorful-winsep"

  winsep.setup(opts)
  vim.schedule(function()
    winsep.enable()
  end)
end

return M
