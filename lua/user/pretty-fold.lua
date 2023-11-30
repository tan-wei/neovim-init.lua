local status_ok, pretty_fold = pcall(require, "prtty-fold")
if not status_ok then
  return
end

-- TODO: Configure for different filetype
pretty_fold.setup()
