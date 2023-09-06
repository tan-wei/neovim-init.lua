local status_ok, git_conflict = pcall(require, "git-conflict")
if not status_ok then
  return
end

-- TODO: Configure for git-conflict.nvim
git_conflict.setup()
