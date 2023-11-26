local status_ok, action_hints = pcall(require, "action-hints")
if not status_ok then
  return
end

action_hints.setup()
