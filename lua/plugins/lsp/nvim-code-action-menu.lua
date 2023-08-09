local M = {
  "weilbith/nvim-code-action-menu",
}

M.init = function()
  vim.g.code_action_menu_window_border = "single"
  vim.g.code_action_menu_show_details = true
  vim.g.code_action_menu_show_diff = true
  vim.g.code_action_menu_show_action_kind = true
end

return M
