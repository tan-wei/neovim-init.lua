local M = {}

M.is_neovide = function()
  if vim.g.neovide then
    return true
  else
    return false
  end
end

M.is_neovim_qt = function()
  if not vim.env.TERM or vim.env.TERM == "" then
    if vim.g.neovide then
      return false
    else
      return true
    end
  else
    return false
  end
end

M.is_gui_client = function()
  return M.is_neovide() or M.is_neovim_qt()
end

M.is_kitty = function()
  return vim.env.TERM == "kitty" or vim.env.TERM == "xterm-kitty"
end

M.is_wezterm = function()
  return vim.env.TERM == "wezterm"
end

M.is_ghostty = function()
  return vim.env.TERM == "xterm-ghostty"
end

M.is_alacritty = function()
  return vim.env.TERM == "alacritty"
end

M.is_windows_terminal = function()
  if vim.fn.has "win32" == 1 then
    local wt_session = os.getenv "WT_SESSION"
    if wt_session ~= nil then
      return true
    else
      return false
    end
  else
    return false
  end
end

M.is_other_terminal = function()
  return vim.env.TERM == "xterm-256color"
end

M.is_cui_client = function()
  return M.is_other_terminal()
    or M.is_wezterm()
    or M.is_kitty()
    or M.is_ghostty()
    or M.is_alacritty()
    or M.is_windows_terminal()
end

return M
