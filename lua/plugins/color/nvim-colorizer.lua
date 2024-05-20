local M = {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
}

M.config = function()
  require("colorizer").setup {
    filetypes = {
      "lua",
      markdown = { names = false }
    },
  }

  -- execute colorizer as soon as possible
  vim.defer_fn(function()
    require("colorizer").attach_to_buffer(0)
  end, 0)
end

return M
