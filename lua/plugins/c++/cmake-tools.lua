local M = {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "cmake", "c", "cpp" },
  cmd = {
    "CMakeGenerate",
    "CMakeBuild",
    "CMakeRun",
    "CMakeDebug",
    "CMakeLaunchArgs",
    "CMakeSelectBuildType",
    "CMakeSelectBuildTarget",
    "CMakeSelectLaunchTarget",
    "CMakeSelectKit",
    "CMakeSelectConfigurePreset",
    "CMakeSelectBuildPreset",
    "CMakeSelectCwd",
    "CMakeSelectBuildDir",
    "CMakeOpen",
    "CMakeClose",
    "CMakeInstall",
    "CMakeClean",
    "CMakeStop",
    "CMakeQuickBuild",
    "CMakeQuickRun",
    "CMakeQuickDebug",
    "CMakeShowTargetFiles",
    "CMakeSettings",
    "CMakeTargetSettings",
  },
}
local function get_number_of_cores()
  local handle = io.popen "nproc"
  local result = handle:read "*a"
  handle:close()
  return tonumber(result)
end

local function build_options()
  if require("util.os").is_windows() then
    return nil
  else
    return { "-j" .. get_number_of_cores() }
  end
end

M.opts = {
  cmake_build_directory = "build/${kit}/${kitGenerator}/${variant:buildType}",
  cmake_build_options = build_options(),
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
  cmake_runner = {
    name = "toggleterm",
  },
}

return M
