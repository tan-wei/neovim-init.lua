local M = {
  "907th/vim-auto-save",
}

M.config = function()
  vim.g.auto_save = 0
  vim.g.auto_save_events = { "InsertLeave", "TextChanged" }
  local group = vim.api.nvim_create_augroup("ft_markdown", { clear = false })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "markdown",
    group = group,
    callback = function()
      vim.b.auto_save = 1
    end,
  })
end

return M
