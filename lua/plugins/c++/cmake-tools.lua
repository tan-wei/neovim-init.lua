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

M.opts = {
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
  cmake_runner = {
    name = "toggleterm",
  },
}

return M
