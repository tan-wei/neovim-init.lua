local M = {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  enabled = false,
}

M.config = function()
  require("colorizer").setup {
    filetypes = {
      "lua",
      markdown = { names = false },
      cpp = { names = false },
    },
    user_default_options = { mode = "background" },
  }

  -- execute colorizer as soon as possible
  vim.defer_fn(function()
    require("colorizer").attach_to_buffer(0)
  end, 0)
end

return M
