local M = {
  "nvim-focus/focus.nvim",
  event = "VeryLazy",
}

M.init = function()
  local ignore_filetypes = { "NvimTree", "Outline" }
  local ignore_buftypes = { "nofile", "prompt", "popup" }

  local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

  vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
        vim.w.focus_disable = true
      else
        vim.w.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for BufType",
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        vim.b.focus_disable = true
      else
        vim.b.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for FileType",
  })
end

M.config = function()
  require("focus").setup {
    ui = {
      cursorline = false,
      colorcolumn = {
        enable = true,
      },
      signcolumn = false,
    },
    autoresize = {
      height_quickfix = 30,
    },
  }
end

return M
