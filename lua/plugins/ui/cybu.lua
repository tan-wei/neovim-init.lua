local M = {
  "ghillb/cybu.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
}

M.init = function()
  vim.keymap.set("n", "[b", "<Plug>(CybuPrev)")
  vim.keymap.set("n", "]b", "<Plug>(CybuNext)")
  vim.keymap.set("n", "<s-tab>", "<plug>(CybuLastusedPrev)")
  vim.keymap.set("n", "<tab>", "<plug>(CybuLastusedNext)")
end

M.opts = {
  exclude = {
    "fugitive",
    "qf",
  },
}

return M
