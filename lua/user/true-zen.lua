local status_ok, true_zen = pcall(require, "true-zen")
if not status_ok then
  return
end

-- Default configure is OK
true_zen.setup()
