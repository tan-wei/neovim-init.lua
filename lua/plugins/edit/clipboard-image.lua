local M = {
  -- "ekickx/clipboard-image.nvim",
  "dfendr/clipboard-image.nvim",
  dependencies = {
    "danielwe/vim-percent",
  },
  ft = { "markdown" },
}

M.opts = {
  default = {
    img_dir = "images",
    img_name = function()
      vim.fn.inputsave()
      local name = vim.fn.input "Name: "
      vim.fn.inputrestore()
      return name
    end,
    affix = "<\n  %s\n>", -- Multi lines affix
  },

  markdown = {
    img_dir = { "%:p:h", "%:t:r" },
    img_dir_txt = function()
      return { "./" .. vim.fn["percent#encode"](vim.fn.expand "%:t:r") }
    end,
  },
}

return M
