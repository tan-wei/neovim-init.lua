local M = {
  "utilyre/sentiment.nvim",
  event = "VeryLazy",
}

M.init = function()
  -- `matchparen.vim` needs to be disabled manually in case of lazy loading
  vim.g.loaded_matchparen = 1
end

M.opts = {
  included_buftypes = {
    [""] = true,
  },
  excluded_filetypes = {},
  included_modes = {
    n = true,
    i = true,
  },
  delay = 50,
  limit = 1000,
  pairs = {
    { "(", ")" },
    { "{", "}" },
    { "[", "]" },
  },
}

return M
