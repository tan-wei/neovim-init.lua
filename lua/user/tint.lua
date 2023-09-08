local status_ok, tint = pcall(require, "tint")
if not status_ok then
  return
end

local ignore_buftypes = {
  terminal = true,
  nofile = true,
}

tint.setup {
  tint = -45,
  saturation = 0.6,
  transforms = tint.transforms.SATURATE_TINT,
  tint_background_colors = true,
  highlight_ignore_patterns = {
    "WinSeparator",
    "Status.*",
    "NvimTree_*",
    "Outline*",
  },
  window_ignore_function = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
    return ignore_buftypes[buftype] or floating
  end,
}
