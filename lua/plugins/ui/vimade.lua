---@type LazyPluginSpec
local M = {
  "TaDaa/vimade",
  event = "VeryLazy",
}

local dim_whitelist_excluded_filetypes = {
  NvimTree = true,
  Outline = true,
  qf = true,
}

local dim_whitelist_excluded_buftypes = {
  nofile = true,
  popup = true,
  prompt = true,
}

local function window_should_never_dim(win)
  return dim_whitelist_excluded_filetypes[win.buf_opts.filetype]
    or dim_whitelist_excluded_buftypes[win.buf_opts.buftype]
end

local function current_window_allows_dimming(current)
  if not current then
    return true
  end

  return not window_should_never_dim(current)
end

M.opts = {
  recipe = { "minimalist", { animate = true } },
  ncmode = "windows",
  fadelevel = 0.4,
  blocklist = {
    disable_when_current_not_whitelisted = function(_, current)
      return not current_window_allows_dimming(current)
    end,
    auxiliary_windows = function(win)
      return window_should_never_dim(win)
    end,
  },
}

return M
