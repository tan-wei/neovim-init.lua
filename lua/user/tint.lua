local status_ok, tint = pcall(require, "tint")
if not status_ok then
  return
end

local ignore_buftypes = {
  terminal = true,
  nofile = true,
  guiuha = true,
}

tint.setup {
  tint = -45,
  saturation = 0.6,
  transforms = tint.transforms.SATURATE_TINT,
  tint_background_colors = true,
  highlight_ignore_patterns = {
    "SignColumn",
    "LineNr",
    "CursorLine",
    "WinSeparator",
    "VertSplit",
    "StatusLineNC",
  },
  window_ignore_function = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
    return ignore_buftypes[buftype] or floating
  end,
}

-- Tint when neovim is not active
vim.api.nvim_create_autocmd("FocusGained", {
  pattern = "*",
  callback = function()
    tint.untint(vim.api.nvim_get_current_win())
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    tint.tint(vim.api.nvim_get_current_win())
  end,
})

-- Do not tint when the active buffer is a special one
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "NvimTree_*", "Outline*" },
  callback = function()
    tint.disable()
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = { "NvimTree_*", "Outline*" },
  callback = function()
    tint.enable()
  end,
})
