local status_ok, executor = pcall(require, "executor")
if not status_ok then
  return
end

executor.setup {
  use_split = false,
  output_filter = function(command, lines)
    return lines
  end,
}
