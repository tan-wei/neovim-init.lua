---@type LazyPluginSpec
local M = {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
}

M.opts = {
  sources = {
    terminal = {
      show_current = true,
      name = function(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        local term = select(2, require("toggleterm.terminal").indentify(name))
        if term then
          return term.display_name or term.name
        else
          return name
        end
      end,
    },
  },
}

return M
