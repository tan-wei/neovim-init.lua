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
  return vim.env.TERM == "kitty"
end

M.is_wezterm = function()
  return vim.env.TERM == "wezterm"
end

M.is_other_terminal = function()
  return vim.env.TERM == "xterm-256color"
end

M.is_cui_client = function()
  return M.is_other_terminal() or M.is_wezterm() or M.is_kitty()
end

return M
