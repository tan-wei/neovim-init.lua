local M = {}

M.is_neovide = function()
  return vim.g.neovide ~= nil
end

M.is_neovim_qt = function()
  return vim.g.nvim_qt ~= nil or vim.env.NVIM_QT_RUNNING == "1"
end

M.is_goneovim = function()
  return vim.g.goneovim ~= nil
end

M.is_fvim = function()
  return vim.g.fvim_loaded ~= nil
end

M.is_gui_client = function()
  return M.is_neovide() or M.is_neovim_qt() or M.is_goneovim() or M.is_fvim() or vim.fn.has "gui_running" == 1
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
    return wt_session ~= nil
  else
    return false
  end
end

M.is_iterm = function()
  return vim.env.ITERM_SESSION_ID ~= nil
end

M.is_cui_client = function()
  return not M.is_gui_client()
end

M.get_client = function()
  if M.is_gui_client() then
    if M.is_neovide() then
      return "neovide"
    end

    if M.is_neovim_qt() then
      return "neovim-qt"
    end

    if M.is_goneovim() then
      return "goneovim"
    end
  else
    if M.is_wezterm() then
      return "wezterm"
    end

    if M.is_ghostty() then
      return "ghostty"
    end

    if M.is_alacritty() then
      return "alacritty"
    end

    if M.is_windows_terminal() then
      return "windows terminal"
    end
  end

  -- NOTE: Unknown default
  return "default"
end

return M
