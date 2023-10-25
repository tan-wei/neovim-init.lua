local status_ok, overseer = pcall(require, "overseer")
if not status_ok then
  return
end

overseer.register_template(require "user.overseer.template.run_script")

overseer.setup()
