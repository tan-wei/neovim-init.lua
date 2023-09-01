local status_ok, godbolt = pcall(require, "godbolt")
if not status_ok then
  return
end

godbolt.setup {
  -- curl https://godbolt.org/api/compilers
  languages = {
    cpp = { compiler = "clang1600", options = {} },
    c = { compiler = "clang1600", options = {} },
    rust = { compiler = "nightly", options = {} },
  },
  quickfix = {
    enable = false, -- whether to populate the quickfix list in case of errors
    auto_open = false, -- whether to open the quickfix list in case of errors
  },
  url = "https://godbolt.org", -- can be changed to a different godbolt instance
}
