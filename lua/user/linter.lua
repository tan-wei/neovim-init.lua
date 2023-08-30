local status_ok, lint = pcall(require, "lint")
if not status_ok then
  return
end

lint.linters_by_ft = {
  cpp = { "clangtidy", "cppcheck" },
}
