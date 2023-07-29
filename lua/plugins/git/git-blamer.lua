local M = {
  "f-person/git-blame.nvim",
}

M.init = function()
  vim.g.gitblame_enabled = 1
  vim.g.gitblame_message_template = "<summary> • <date> • <author>"
end

return M
