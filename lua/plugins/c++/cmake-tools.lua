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
    "CMakeClearSession",
  },
}
local function get_number_of_cores()
  if require("util.os").is_linux() then
    local handle = io.popen "nproc"
    local result = handle:read "*a"
    handle:close()
    return tonumber(result)
  elseif require("util.os").is_macos() then
    local handle = io.popen "sysctl -n hw.ncpu"
    local result = handle:read "*a"
    handle:close()
    return tonumber(result)
  else
    return 1
  end
end

local function build_options()
  return { "-j" .. get_number_of_cores() }
end

local function get_session_cache_dir()
  if require("util.os").is_windows() then
    return vim.fn.expand "~" .. "/AppData/Local/cmake_tools_nvim/"
  end

  return vim.fn.expand "~" .. "/.cache/cmake_tools_nvim/"
end

local function get_session_path(cwd)
  local clean_path = cwd:gsub("/", "")
  clean_path = clean_path:gsub("\\", "")
  clean_path = clean_path:gsub(":", "")
  return get_session_cache_dir() .. clean_path .. ".lua"
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

M.config = function(_, opts)
  local cmake_tools = require "cmake-tools"

  cmake_tools.setup(opts)

  -- After CMakeGenerate/CMakeBuild completes successfully, restart C++ LSP
  -- so it picks up the new/updated compile_commands.json.
  local function on_cmake_done(result)
    if result:is_ok() then
      vim.schedule(function()
        local restarted = {}
        local bufnr = vim.api.nvim_get_current_buf()
        for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
          if client.name == "clangd" or client.name == "ccls" then
            table.insert(restarted, client.name)
            client:stop()
          end
        end
        if #restarted > 0 then
          vim.defer_fn(function()
            -- Re-attach by triggering FileType event on current buffer only
            vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })
            vim.notify(
              "LSP restarted: " .. table.concat(restarted, ", ") .. " (compile_commands.json updated)",
              vim.log.levels.INFO
            )
          end, 500)
        end
      end)
    end
  end

  pcall(vim.api.nvim_del_user_command, "CMakeGenerate")
  vim.api.nvim_create_user_command("CMakeGenerate", function(cmd_opts)
    cmake_tools.generate({ bang = cmd_opts.bang, fargs = cmd_opts.fargs }, on_cmake_done)
  end, { bang = true, nargs = "*", desc = "CMake Generate (with LSP restart)" })

  pcall(vim.api.nvim_del_user_command, "CMakeBuild")
  vim.api.nvim_create_user_command("CMakeBuild", function(cmd_opts)
    cmake_tools.build({ bang = cmd_opts.bang, fargs = cmd_opts.fargs }, on_cmake_done)
  end, { bang = true, nargs = "*", desc = "CMake Build (with LSP restart)" })

  pcall(vim.api.nvim_del_user_command, "CMakeClearSession")
  vim.api.nvim_create_user_command("CMakeClearSession", function()
    local cwd = vim.loop.cwd()
    if not cwd or cwd == "" then
      vim.notify("Unable to determine current working directory", vim.log.levels.ERROR)
      return
    end

    local session_path = get_session_path(cwd)
    local existed = vim.uv.fs_stat(session_path) ~= nil

    if existed and vim.fn.delete(session_path) ~= 0 then
      vim.notify("Failed to remove cmake-tools session: " .. session_path, vim.log.levels.ERROR)
      return
    end

    cmake_tools.setup(vim.deepcopy(opts))

    if existed then
      vim.notify("Cleared cmake-tools session for " .. cwd)
    else
      vim.notify("Reset cmake-tools state for " .. cwd .. " (no persisted session file found)")
    end
  end, {
    desc = "Clear cmake-tools session for current working directory",
  })
end

return M
