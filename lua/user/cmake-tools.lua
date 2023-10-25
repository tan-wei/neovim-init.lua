local status_ok, cmake_tools = pcall(require, "cmake-tools")
if not status_ok then
  return
end

cmake_tools.setup {
  cmake_build_directory = "build",
  cmake_soft_link_compile_commands = false,
  cmake_compile_commands_from_lsp = true,
  cmake_executor = {
    name = "quickfix",
    opts = {},
    default_opts = {
      quickfix = {
        show = "only_on_error",
        position = "belowright",
        size = 10,
      },
      overseer = {
        new_task_opts = {},
        on_new_task = function(task) end,
      },
      terminal = {},
    },
  },
}
