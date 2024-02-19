local M = {
  "micarmst/vim-spellsync",
  lazy = false,
}

M.init = function()
  vim.g.spellsync_run_at_startup = 1
  vim.g.spellsync_enable_git_union_merge = 1
  vim.g.spellsync_enable_git_ignore = 1
end

return M
