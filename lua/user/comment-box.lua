local status_ok, comment_box = pcall(require, "comment-box")
if not status_ok then
  return
end

-- TODO: Configure for comment-box.nvim
comment_box.setup()
