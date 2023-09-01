local status_ok, numbers = pcall(require, "numbers")
if not status_ok then
  return
end

numbers.setup {
  excluded_filetypes = {
    "lazy",
  },
}
