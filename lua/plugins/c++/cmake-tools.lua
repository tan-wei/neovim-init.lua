---@type LazyPluginSpec
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
    "CMakeRunTest",
    "CMakeDebug",
    "CMakeLaunchArgs",
    "CMakeSelectBuildType",
    "CMakeSelectBuildTarget",
    "CMakeSelectLaunchTarget",
    "CMakeKits",
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
    "CMakeSelectProject",
    "CMakeShowTargetFiles",
    "CMakeSettings",
    "CMakeTargetSettings",
    "CMakeClearSession",
  },
}

local function build_options()
  return { "-j" .. require("util.os").get_cpu_count() }
end

local function open_overseer_task_list()
  local ok, overseer = pcall(require, "overseer")
  if ok then
    overseer.open { enter = false, direction = "right" }
  end
end

local function shorten_cmake_overseer_task_name(task)
  if type(task) ~= "table" or type(task.name) ~= "string" then
    return
  end

  local name = task.name:lower()
  if name:find(" --build ", 1, true) or name:match "%-%-build$" then
    if name:find(" --target clean", 1, true) then
      task.name = "CMake Clean"
    else
      task.name = "CMake Build"
    end
    return
  end

  if name:find(" --install ", 1, true) or name:match "%-%-install$" then
    task.name = "CMake Install"
    return
  end

  task.name = "CMake Task"
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
  cmake_kits_path = require("util.cmake_kits").get_path(),
  cmake_kit_scanner = {
    additional_search_dirs = {},
    additional_compiler_search_dirs = {},
    mingw_search_dirs = {},
    msvc_search_dirs = {},
    use_macos_default_search_dirs = true,
    use_mingw_default_search_dirs = true,
    use_msvc_default_search_dirs = true,
    vswhere_path = nil,
    msvc_command = nil,
  },
  cmake_project_discovery = {
    entry_filters = {
      enabled = true,
      exclude_path_patterns = {
        "/vendor/",
        "/third_party/",
        "/third-party/",
        "/_deps/",
        "/deps/",
        "/vcpkg_installed/",
      },
    },
  },
  cmake_executor = {
    name = "overseer",
    opts = {},
    default_opts = {
      quickfix = {
        show = "only_on_error",
        position = "belowright",
        size = 10,
        encoding = "utf-8",
        auto_close_when_success = true,
      },
      overseer = {
        new_task_opts = {
          components = {
            "on_exit_set_status",
            { "on_complete_notify", statuses = { "FAILURE" } },
            { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
            {
              "on_output_quickfix",
              open = false,
              open_on_exit = "failure",
              open_height = 10,
              focus = true,
              items_only = true,
              set_diagnostics = true,
              tail = false,
            },
          },
        },
        on_new_task = function(task)
          shorten_cmake_overseer_task_name(task)
        end,
      },
      terminal = {},
    },
  },
  cmake_runner = {
    name = "overseer",
    opts = {},
    default_opts = {
      quickfix = {
        show = "only_on_error",
        position = "belowright",
        size = 10,
        encoding = "utf-8",
        auto_close_when_success = true,
      },
      toggleterm = {
        direction = "float",
        close_on_exit = false,
        auto_scroll = true,
        singleton = true,
      },
      overseer = {
        new_task_opts = {},
        on_new_task = function(task)
          open_overseer_task_list()
        end,
      },
      terminal = {},
    },
  },
}

M.config = function(_, opts)
  local cmake_tools = require "cmake-tools"
  local cmake_variants = require "cmake-tools.variants"
  local kit_scanner = require "util.cmake_kits"
  local cmake_project = require "util.cmake_project"
  local discovery_group = vim.api.nvim_create_augroup("user-cmake-tools-discovery", { clear = true })
  local on_cmake_done

  local kits_subcommands = {
    scan = { "--verbose", "-v" },
    list = { "--verbose", "-v" },
    edit = {},
    select = { "--verbose", "-v", "--rescan", "--build-type", "--variant" },
  }

  local function get_upvalue(fn, target)
    if type(fn) ~= "function" then
      return nil
    end

    for index = 1, 20 do
      local name, value = debug.getupvalue(fn, index)
      if not name then
        return nil
      end
      if name == target then
        return value
      end
    end

    return nil
  end

  local function get_cmake_config()
    return get_upvalue(cmake_tools.select_kit, "config")
  end

  local function filter_completion(items, arglead)
    local matches = {}
    for _, item in ipairs(items) do
      if item:find("^" .. vim.pesc(arglead)) then
        table.insert(matches, item)
      end
    end
    return matches
  end

  local function parse_kits_command_args(fargs)
    local parsed = {
      subcommand = fargs[1],
      verbose = false,
      rescan = false,
      select_build_type = false,
      build_type = nil,
      unknown = {},
    }

    local index = 2
    while index <= #fargs do
      local arg = fargs[index]
      if arg == "--verbose" or arg == "-v" then
        parsed.verbose = true
      elseif arg == "--rescan" then
        parsed.rescan = true
      elseif arg == "--build-type" or arg == "--variant" then
        parsed.select_build_type = true
        local next_arg = fargs[index + 1]
        if next_arg and not next_arg:match "^%-" then
          parsed.build_type = next_arg
          index = index + 1
        end
      else
        table.insert(parsed.unknown, arg)
      end
      index = index + 1
    end

    return parsed
  end

  local function get_build_type_choices(cwd)
    local _, choices = cmake_variants.get({
      short = { show = true },
      long = { show = true, max_length = 40 },
    }, cwd)

    return choices or {}
  end

  local function complete_build_type(arglead)
    local matches = {}
    local prefix = (arglead or ""):lower()

    for _, choice in ipairs(get_build_type_choices(vim.loop.cwd())) do
      local short = choice.short or ""
      if prefix == "" or short:lower():find("^" .. vim.pesc(prefix)) then
        table.insert(matches, short)
      end
    end

    return matches
  end

  local function find_build_type_choice(cwd, requested)
    if not requested or requested == "" then
      return nil
    end

    local requested_lower = requested:lower()
    for _, choice in ipairs(get_build_type_choices(cwd)) do
      local short = choice.short or ""
      if short == requested or short:lower() == requested_lower then
        return choice
      end
    end

    return nil
  end

  local function complete_kits_command(arglead, cmdline, cursorpos)
    local before_cursor = cmdline:sub(1, cursorpos)
    local parts = vim.split(before_cursor, "%s+", { trimempty = true })

    if #parts <= 1 then
      return filter_completion(vim.tbl_keys(kits_subcommands), arglead)
    end

    if #parts == 2 and not before_cursor:match "%s$" then
      return filter_completion(vim.tbl_keys(kits_subcommands), arglead)
    end

    local previous = parts[#parts - 1]
    local current = parts[#parts]
    if previous == "--build-type" or previous == "--variant" then
      return complete_build_type(arglead)
    end

    if before_cursor:match "%s$" and (current == "--build-type" or current == "--variant") then
      return complete_build_type ""
    end

    local subcommand = parts[2]
    local flags = kits_subcommands[subcommand] or {}
    return filter_completion(flags, arglead)
  end

  local function show_kits_usage(level)
    vim.notify(
      "Usage: :CMakeKits scan|list|edit|select [--verbose] [--rescan] [--build-type [name]]",
      level or vim.log.levels.INFO
    )
  end

  local function notify_scan_result(result)
    if #result.scanned_kits == 0 then
      vim.notify("CMake kits: no compiler kits found", vim.log.levels.WARN)
      return
    end

    vim.notify(
      string.format("CMake kits: %d scanned, %d total", #result.scanned_kits, #result.kits),
      vim.log.levels.INFO
    )
  end

  local function run_scan(scan_opts, on_complete)
    scan_opts = scan_opts or {}

    if scan_opts.verbose then
      vim.notify("CMake kits: scanning PATH (verbose)", vim.log.levels.INFO)
    else
      vim.notify("CMake kits: scanning PATH", vim.log.levels.INFO)
    end

    kit_scanner.scan_async(scan_opts, function(result)
      notify_scan_result(result)
      if type(on_complete) == "function" then
        on_complete(result)
      end
    end)
  end

  local generate_with_quickfix

  local function select_kit_with_details(select_opts)
    select_opts = select_opts or {}
    local cwd = vim.loop.cwd()
    local kits = kit_scanner.read_effective_kits(cwd)
    local active_config = get_cmake_config()

    if #kits == 0 then
      vim.notify("No CMake kits available for the current project", vim.log.levels.WARN)
      return
    end

    table.sort(kits, function(left, right)
      if active_config and left.name == active_config.kit then
        return true
      end
      if active_config and right.name == active_config.kit then
        return false
      end
      return (left.name or "") < (right.name or "")
    end)

    vim.ui.select(kits, {
      prompt = "Select CMake kit",
      format_item = function(item)
        return kit_scanner.format_selection_item(item, { verbose = select_opts.verbose == true })
      end,
    }, function(choice)
      if not choice then
        return
      end

      if not active_config then
        vim.notify("Unable to access cmake-tools state for kit selection", vim.log.levels.ERROR)
        return
      end

      local previous_kit = active_config.kit
      local previous_build_type = active_config.build_type

      local function apply_build_type_choice(build_type_choice)
        if not build_type_choice then
          return
        end

        active_config.build_type = build_type_choice.short
        active_config.variant = build_type_choice.kv
      end

      local function finalize_selection()
        local kit_changed = previous_kit ~= choice.name
        local build_type_changed = previous_build_type ~= active_config.build_type

        active_config.kit = choice.name

        if build_type_changed and active_config.build_type then
          vim.notify(
            string.format("Selected CMake kit: %s | build type: %s", choice.name, active_config.build_type),
            vim.log.levels.INFO
          )
        else
          vim.notify("Selected CMake kit: " .. choice.name, vim.log.levels.INFO)
        end

        if kit_changed or build_type_changed then
          generate_with_quickfix({ bang = false, fargs = {} }, on_cmake_done)
        end
      end

      if select_opts.build_type then
        local build_type_choice = find_build_type_choice(cwd, select_opts.build_type)
        if not build_type_choice then
          vim.notify("Unknown CMake build type: " .. select_opts.build_type, vim.log.levels.ERROR)
          return
        end

        apply_build_type_choice(build_type_choice)
        finalize_selection()
        return
      end

      if select_opts.select_build_type then
        cmake_tools.select_build_type(function(result)
          if not result or not result:is_ok() then
            return
          end

          finalize_selection()
        end)
        return
      end

      finalize_selection()
    end)
  end

  local function get_generate_quickfix_opts()
    local quickfix_defaults = ((((opts or {}).cmake_executor or {}).default_opts or {}).quickfix or {})
    local quickfix_opts = vim.deepcopy(quickfix_defaults)

    quickfix_opts.show = quickfix_opts.show or "only_on_error"
    quickfix_opts.position = quickfix_opts.position or "belowright"
    quickfix_opts.size = quickfix_opts.size or 10
    quickfix_opts.encoding = quickfix_opts.encoding or "utf-8"
    if quickfix_opts.auto_close_when_success == nil then
      quickfix_opts.auto_close_when_success = true
    end

    return quickfix_opts
  end

  generate_with_quickfix = function(cmd_opts, callback)
    local active_config = get_cmake_config()
    if not active_config or type(active_config) ~= "table" then
      return cmake_tools.generate(cmd_opts, callback)
    end

    local previous_executor = active_config.executor
    local restored = false

    local function restore_executor()
      if restored then
        return
      end

      restored = true
      active_config.executor = previous_executor
    end

    active_config.executor = vim.tbl_deep_extend("force", vim.deepcopy(previous_executor or {}), {
      name = "quickfix",
      opts = get_generate_quickfix_opts(),
    })

    local function wrapped_callback(result)
      restore_executor()

      if result and not result:is_ok() then
        vim.notify("CMake generate failed; see quickfix for details", vim.log.levels.ERROR)
      end

      if type(callback) == "function" then
        callback(result)
      end
    end

    local ok, err = pcall(cmake_tools.generate, cmd_opts, wrapped_callback)
    if not ok then
      restore_executor()
      error(err)
    end
  end

  local scanner_opts = vim.deepcopy(opts.cmake_kit_scanner or {})
  local project_discovery_opts = vim.deepcopy(opts.cmake_project_discovery or {})
  local cmake_opts = vim.deepcopy(opts)
  cmake_opts.cmake_kit_scanner = nil
  cmake_opts.cmake_project_discovery = nil

  cmake_tools.setup(cmake_opts)
  kit_scanner.setup(scanner_opts)
  cmake_project.setup(project_discovery_opts)

  -- After CMakeGenerate/CMakeBuild completes successfully, restart C++ LSP
  -- so it picks up the new/updated compile_commands.json.
  on_cmake_done = function(result)
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
    generate_with_quickfix({ bang = cmd_opts.bang, fargs = cmd_opts.fargs }, on_cmake_done)
  end, { bang = true, nargs = "*", desc = "CMake Generate (with LSP restart)" })

  pcall(vim.api.nvim_del_user_command, "CMakeBuild")
  vim.api.nvim_create_user_command("CMakeBuild", function(cmd_opts)
    cmake_tools.build({ bang = cmd_opts.bang, fargs = cmd_opts.fargs }, on_cmake_done)
  end, { bang = true, nargs = "*", desc = "CMake Build (with LSP restart)" })

  pcall(vim.api.nvim_del_user_command, "CMakeSelectKit")
  pcall(vim.api.nvim_del_user_command, "CMakeScanKits")
  pcall(vim.api.nvim_del_user_command, "CMakeUpdateKits")
  pcall(vim.api.nvim_del_user_command, "CMakeListKits")
  pcall(vim.api.nvim_del_user_command, "CMakeEditKits")
  pcall(vim.api.nvim_del_user_command, "CMakeKits")
  vim.api.nvim_create_user_command("CMakeKits", function(cmd_opts)
    local parsed = parse_kits_command_args(cmd_opts.fargs)
    local cwd = vim.loop.cwd()

    if not parsed.subcommand then
      show_kits_usage()
      return
    end

    if not kits_subcommands[parsed.subcommand] then
      vim.notify("Unknown CMakeKits subcommand: " .. parsed.subcommand, vim.log.levels.ERROR)
      show_kits_usage(vim.log.levels.ERROR)
      return
    end

    if #parsed.unknown > 0 then
      vim.notify("Unknown CMakeKits option(s): " .. table.concat(parsed.unknown, ", "), vim.log.levels.ERROR)
      show_kits_usage(vim.log.levels.ERROR)
      return
    end

    if parsed.subcommand == "scan" then
      run_scan { verbose = parsed.verbose }
      return
    end

    if parsed.subcommand == "list" then
      kit_scanner.show_effective_kits(vim.loop.cwd(), { verbose = parsed.verbose })
      return
    end

    if parsed.subcommand == "edit" then
      local path = kit_scanner.edit_user_local_kits()
      vim.notify("Editing user-local CMake kits: " .. path, vim.log.levels.INFO)
      return
    end

    if kit_scanner.has_project_local_kits(cwd) then
      select_kit_with_details {
        verbose = parsed.verbose,
        select_build_type = parsed.select_build_type,
        build_type = parsed.build_type,
      }
      return
    end

    if parsed.rescan or #kit_scanner.read_user_local_kits() == 0 then
      run_scan({ verbose = parsed.verbose }, function(result)
        if #result.kits == 0 then
          vim.notify("No CMake kits found. Install gcc/clang or add a local CMakeKits.json first.", vim.log.levels.WARN)
          return
        end

        select_kit_with_details {
          verbose = parsed.verbose,
          select_build_type = parsed.select_build_type,
          build_type = parsed.build_type,
        }
      end)
      return
    end

    select_kit_with_details {
      verbose = parsed.verbose,
      select_build_type = parsed.select_build_type,
      build_type = parsed.build_type,
    }
  end, {
    nargs = "*",
    complete = complete_kits_command,
    desc = "Manage CMake kits: scan, list, edit, select",
  })

  pcall(vim.api.nvim_del_user_command, "CMakeSelectProject")
  vim.api.nvim_create_user_command("CMakeSelectProject", function(cmd_opts)
    local list_all = false
    local unknown = {}
    for _, arg in ipairs(cmd_opts.fargs or {}) do
      if arg == "--all" then
        list_all = true
      else
        table.insert(unknown, arg)
      end
    end

    if #unknown > 0 then
      vim.notify("Unknown CMakeSelectProject option(s): " .. table.concat(unknown, ", "), vim.log.levels.ERROR)
      return
    end

    local current_path = vim.api.nvim_buf_get_name(0)
    local scan_target = current_path ~= "" and current_path or vim.loop.cwd()

    if list_all then
      local entries = cmake_project.scan_entries(scan_target)
      if #entries == 0 then
        vim.notify("No CMakeLists.txt found under current repository or working directory", vim.log.levels.WARN)
        return
      end

      if #entries == 1 then
        cmake_project.select_root(entries[1].root)
        vim.notify("Active CMake root -> " .. entries[1].root, vim.log.levels.INFO)
        return
      end

      vim.ui.select(entries, {
        prompt = "Select CMakeLists.txt",
        format_item = function(item)
          return item.relative .. " | root=" .. item.root_relative
        end,
      }, function(choice)
        if not choice then
          return
        end

        cmake_project.select_root(choice.root)
        vim.notify("Active CMake root -> " .. choice.root, vim.log.levels.INFO)
      end)
      return
    end

    local roots = cmake_project.scan_roots(scan_target)
    if #roots == 0 then
      vim.notify("No CMake project found under current repository or working directory", vim.log.levels.WARN)
      return
    end

    if #roots == 1 then
      cmake_project.select_root(roots[1])
      vim.notify("Active CMake root -> " .. roots[1], vim.log.levels.INFO)
      return
    end

    vim.ui.select(roots, {
      prompt = "Select CMake project root",
    }, function(choice)
      if not choice then
        return
      end

      cmake_project.select_root(choice)
      vim.notify("Active CMake root -> " .. choice, vim.log.levels.INFO)
    end)
  end, {
    nargs = "*",
    complete = function(arglead)
      return filter_completion({ "--all" }, arglead)
    end,
    desc = "Scan current repository or working directory for CMake projects and select one",
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
    group = discovery_group,
    desc = "Keep cmake-tools.nvim attached to the active CMake project root",
    callback = function(args)
      if args.event == "DirChanged" then
        local current_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        local scan_target = current_path ~= "" and current_path or vim.loop.cwd()
        if not cmake_project.sync_buffer(vim.api.nvim_get_current_buf()) then
          cmake_project.suggest_root(scan_target, {
            prompt = true,
            prompt_text = "Select CMake project root",
            on_select = function(choice)
              vim.notify("Active CMake root -> " .. choice, vim.log.levels.INFO)
            end,
          })
        end
        return
      end

      if not cmake_project.sync_buffer(args.buf) then
        cmake_project.suggest_root(vim.api.nvim_buf_get_name(args.buf), {
          prompt = true,
          prompt_text = "Select CMake project root",
          on_select = function(choice)
            vim.notify("Active CMake root -> " .. choice, vim.log.levels.INFO)
          end,
        })
      end
    end,
  })

  vim.schedule(function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_path = vim.api.nvim_buf_get_name(current_buf)
    local scan_target = current_path ~= "" and current_path or vim.loop.cwd()
    if not cmake_project.sync_buffer(current_buf) then
      cmake_project.suggest_root(scan_target, {
        prompt = true,
        prompt_text = "Select CMake project root",
        on_select = function(choice)
          vim.notify("Active CMake root -> " .. choice, vim.log.levels.INFO)
        end,
      })
    end
  end)

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
