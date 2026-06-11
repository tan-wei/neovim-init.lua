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

---Check if the current window is a floating window. When focus is on a
---floating window (e.g. LSP hover, noice popup, completion menu), ALL
---background windows should dim, including whitelisted ones like NvimTree.
---
---Note: we intentionally do NOT check for non-focused floating windows
---because plugins like noice keep persistent floating windows (cmdline)
---that would otherwise permanently disable the whitelist.
---@return boolean
local function current_window_is_floating()
  local current_win = vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(current_win)
  return cfg.relative ~= ""
end

local function window_should_never_dim(win)
  -- When focus is on a floating window, everything behind it should dim,
  -- even whitelisted buffer types.
  if current_window_is_floating() then
    return false
  end
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
  recipe = { "ripple", { animate = true } },
  ncmode = "windows",
  fadelevel = 0.4,
  blocklist = {
    disable_when_current_not_whitelisted = function(_, current)
      return not current_window_allows_dimming(current)
    end,
    auxiliary_windows = function(win)
      return window_should_never_dim(win)
    end,
    -- Floating windows themselves should never be dimmed.
    -- They are the "active" overlay; only background windows dim.
    floating_windows = function(win)
      return win.win_config.relative ~= ""
    end,
  },
}

return M
