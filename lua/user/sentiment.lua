local status_ok, sentiment = pcall(require, "sentiment")
if not status_ok then
  return
end

sentiment.setup {
  included_buftypes = {
    [""] = true,
  },
  excluded_filetypes = {},
  included_modes = {
    n = true,
    i = true,
  },
  delay = 50,
  limit = 1000,
  pairs = {
    { "(", ")" },
    { "{", "}" },
    { "[", "]" },
  },
}
