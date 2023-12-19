local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
}

M.opts = {
  search = {
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      function(win)
        return not vim.api.nvim_win_get_config(win).focusable
      end,
      "NvimTree",
    },
    highlight = {
      backdrop = true,
    },
  },
  label = {
    rainbow = {
      enabled = true,
    },
  },
}

return M
