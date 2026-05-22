---@type table<string, any>
local M = {}

local config = {
  additional_search_dirs = {},
  additional_compiler_search_dirs = {},
  mingw_search_dirs = {},
  msvc_search_dirs = {},
  prefer_ninja = true,
  scan_batch_size = 4,
  use_macos_default_search_dirs = true,
  use_mingw_default_search_dirs = true,
  use_msvc_default_search_dirs = true,
  vswhere_path = nil,
  msvc_command = nil,
}

local msvc_architectures = {
  {
    label = "x64",
    host_architecture = "x64",
    target_architecture = "x64",
    compiler_subdir = "Hostx64/x64",
    vsdevcmd_args = { "-no_logo", "-host_arch=x64", "-arch=x64" },
    vcvarsall_args = { "amd64" },
  },
  {
    label = "x86",
    host_architecture = "x86",
    target_architecture = "x86",
    compiler_subdir = "Hostx86/x86",
    vsdevcmd_args = { "-no_logo", "-host_arch=x86", "-arch=x86" },
    vcvarsall_args = { "x86" },
  },
}

local ui_state = {
  report_bufnr = nil,
}

local read_command_output
local system_text_async
local render_scan_progress

local function generated_kits_dir()
  return vim.fs.joinpath(vim.fn.stdpath "data", "cmake-tools")
end

local function generated_kits_path()
  return vim.fs.joinpath(generated_kits_dir(), "cmake-tools-kits.json")
end

local function normalize_dir(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function stat_path(path)
  local normalized = normalize_dir(path)
  if not normalized then
    return nil, nil
  end

  local stat = vim.uv.fs_stat(normalized)
  return normalized, stat
end

local function is_existing_dir(path)
  local _, stat = stat_path(path)
  return stat ~= nil and stat.type == "directory"
end

local function is_existing_file(path)
  local _, stat = stat_path(path)
  return stat ~= nil and stat.type == "file"
end

local function split_lines(text)
  return vim.split(text or "", "\n", { trimempty = true })
end

local function trim_lines(lines)
  local normalized = {}

  for _, line in ipairs(lines or {}) do
    local trimmed = vim.trim(line)
    if trimmed ~= "" then
      table.insert(normalized, trimmed)
    end
  end

  return normalized
end

local function decode_json_text(text)
  local content = vim.trim(text or "")
  if content == "" then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  return decoded
end

local function split_env_path(path_value)
  local entries = {}
  local separator = require("util.os").is_windows() and ";" or ":"

  for entry in string.gmatch(path_value or "", "([^" .. separator .. "]+)") do
    local normalized = normalize_dir(entry)
    if normalized then
      table.insert(entries, normalized)
    end
  end

  return entries
end

local function expand_search_dir(path)
  local expanded = vim.fn.expand(path)
  if expanded == "" then
    return nil
  end

  return normalize_dir(expanded)
end

local function append_scan_dir_candidates(target, dirs)
  for _, dir in ipairs(dirs or {}) do
    local normalized = expand_search_dir(dir)
    if normalized then
      table.insert(target, normalized)
      table.insert(target, vim.fs.joinpath(normalized, "bin"))
    end
  end
end

local function unique_dirs(dirs)
  local seen = {}
  local results = {}

  for _, dir in ipairs(dirs) do
    local normalized = normalize_dir(dir)
    if normalized and not seen[normalized] and vim.uv.fs_stat(normalized) ~= nil then
      seen[normalized] = true
      table.insert(results, normalized)
    end
  end

  return results
end

local function unique_files(paths)
  local seen = {}
  local results = {}

  for _, path in ipairs(paths or {}) do
    local normalized = normalize_dir(path)
    if normalized and not seen[normalized] and is_existing_file(normalized) then
      seen[normalized] = true
      table.insert(results, normalized)
    end
  end

  return results
end

local function normalize_env_name(name)
  if require("util.os").is_windows() then
    return string.upper(name)
  end

  return name
end

local function current_environment_lookup()
  local lookup = {}

  for key, value in pairs(vim.fn.environ()) do
    lookup[normalize_env_name(key)] = tostring(value)
  end

  return lookup
end

local function environment_delta_from_text(text)
  local current_environment = current_environment_lookup()
  local changed = {}

  for _, line in ipairs(split_lines(text)) do
    local key, value = line:match "^([^=]+)=(.*)$"
    if key and key ~= "" then
      local normalized_key = normalize_env_name(key)
      if current_environment[normalized_key] ~= value then
        changed[key] = value
      end
    end
  end

  return next(changed) and changed or nil
end

local function compare_version_strings(left, right)
  local left_parts = vim.split(left or "", ".", { trimempty = true })
  local right_parts = vim.split(right or "", ".", { trimempty = true })
  local total = math.max(#left_parts, #right_parts)

  for index = 1, total do
    local left_part = left_parts[index] or "0"
    local right_part = right_parts[index] or "0"
    local left_number = tonumber(left_part)
    local right_number = tonumber(right_part)

    if left_number and right_number then
      if left_number ~= right_number then
        return left_number > right_number
      end
    elseif left_part ~= right_part then
      return left_part > right_part
    end
  end

  return false
end

local function sort_candidates(candidates)
  table.sort(candidates, function(left, right)
    local left_family = left.family or ""
    local right_family = right.family or ""
    if left_family ~= right_family then
      return left_family < right_family
    end

    local left_name = left.name_hint or ""
    local right_name = right.name_hint or ""
    if left_name ~= right_name then
      return left_name < right_name
    end

    local left_prefix = left.prefix or ""
    local right_prefix = right.prefix or ""
    if left_prefix ~= right_prefix then
      return left_prefix < right_prefix
    end

    local left_compiler = left.CXX or left.C or ""
    local right_compiler = right.CXX or right.C or ""
    return left_compiler < right_compiler
  end)
end

local function each_async(items, iterator, on_complete)
  local index = 1

  local function step()
    local item = items[index]
    if item == nil then
      if type(on_complete) == "function" then
        on_complete()
      end
      return
    end

    index = index + 1
    iterator(item, step)
  end

  step()
end

local function log_scan_progress(session, message)
  if not session or not session.verbose then
    return
  end

  table.insert(session.logs, message)
  render_scan_progress(session)
end

local function collect_default_msvc_search_dirs()
  local dirs = {}

  for _, base in ipairs { vim.env["ProgramFiles(x86)"], vim.env.ProgramFiles } do
    if base and base ~= "" then
      local root = vim.fs.joinpath(base, "Microsoft Visual Studio")
      table.insert(dirs, root)
      table.insert(dirs, vim.fs.joinpath(root, "2022"))
      table.insert(dirs, vim.fs.joinpath(root, "2019"))
      table.insert(dirs, vim.fs.joinpath(root, "2017"))
    end
  end

  return dirs
end

local function is_visual_studio_installation(path)
  return is_existing_file(vim.fs.joinpath(path, "Common7", "Tools", "VsDevCmd.bat"))
    or is_existing_file(vim.fs.joinpath(path, "VC", "Auxiliary", "Build", "vcvarsall.bat"))
    or is_existing_dir(vim.fs.joinpath(path, "VC", "Tools", "MSVC"))
end

local function collect_nested_directories(root, max_depth)
  local results = {}
  local seen = {}

  local function walk(dir, depth)
    local normalized = normalize_dir(dir)
    if not normalized or seen[normalized] or depth > max_depth or not is_existing_dir(normalized) then
      return
    end

    seen[normalized] = true
    table.insert(results, normalized)

    if depth == max_depth then
      return
    end

    for name, entry_type in vim.fs.dir(normalized) do
      if entry_type == "directory" then
        walk(vim.fs.joinpath(normalized, name), depth + 1)
      end
    end
  end

  walk(root, 0)
  return results
end

local function collect_msvc_installations_from_dirs(add_installation)
  local roots = {}

  if config.use_msvc_default_search_dirs ~= false then
    vim.list_extend(roots, collect_default_msvc_search_dirs())
  end

  for _, dir in ipairs(config.msvc_search_dirs or {}) do
    local normalized = expand_search_dir(dir)
    if normalized and not normalized:lower():match "vswhere%.exe$" then
      table.insert(roots, normalized)
    end
  end

  for _, root in ipairs(unique_dirs(roots)) do
    if is_visual_studio_installation(root) then
      add_installation { installationPath = root }
    else
      for _, candidate in ipairs(collect_nested_directories(root, 2)) do
        if candidate ~= root and is_visual_studio_installation(candidate) then
          add_installation { installationPath = candidate }
        end
      end
    end
  end
end

local function collect_vswhere_candidates()
  local candidates = {}

  local function add_candidate(path)
    if path and path ~= "" then
      table.insert(candidates, path)
    end
  end

  add_candidate(config.vswhere_path)

  for _, dir in ipairs(config.msvc_search_dirs or {}) do
    local normalized = expand_search_dir(dir)
    if normalized then
      if normalized:lower():match "vswhere%.exe$" then
        add_candidate(normalized)
      else
        add_candidate(vim.fs.joinpath(normalized, "vswhere.exe"))
        add_candidate(vim.fs.joinpath(normalized, "Installer", "vswhere.exe"))
      end
    end
  end

  if config.use_msvc_default_search_dirs ~= false then
    for _, base in ipairs { vim.env["ProgramFiles(x86)"], vim.env.ProgramFiles } do
      if base and base ~= "" then
        add_candidate(vim.fs.joinpath(base, "Microsoft Visual Studio", "Installer", "vswhere.exe"))
      end
    end
  end

  return unique_files(candidates)
end

local function parse_vswhere_output(text)
  local decoded = decode_json_text(text)
  if decoded.installationPath then
    decoded = { decoded }
  end

  local results = {}
  for _, item in ipairs(decoded) do
    if type(item) == "table" and type(item.installationPath) == "string" then
      table.insert(results, {
        installationPath = normalize_dir(item.installationPath),
        displayName = item.displayName,
        installationVersion = item.installationVersion,
      })
    end
  end

  return results
end

local function make_msvc_installation_collector()
  local installations = {}
  local seen = {}

  local function add_installation(item)
    if type(item) ~= "table" then
      return
    end

    local path = normalize_dir(item.installationPath)
    if not path or seen[path] or not is_visual_studio_installation(path) then
      return
    end

    seen[path] = true
    table.insert(installations, {
      installationPath = path,
      displayName = item.displayName,
      installationVersion = item.installationVersion,
    })
  end

  return installations, add_installation
end

local function discover_msvc_installations_sync()
  local installations, add_installation = make_msvc_installation_collector()

  collect_msvc_installations_from_dirs(add_installation)

  for _, vswhere_path in ipairs(collect_vswhere_candidates()) do
    local output = read_command_output {
      vswhere_path,
      "-products",
      "*",
      "-requires",
      "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
      "-format",
      "json",
      "-utf8",
    }

    if output then
      for _, installation in ipairs(parse_vswhere_output(table.concat(output, "\n"))) do
        add_installation(installation)
      end
    end
  end

  table.sort(installations, function(left, right)
    return (left.installationPath or "") < (right.installationPath or "")
  end)

  return installations
end

local function discover_msvc_installations_async(on_complete)
  local installations, add_installation = make_msvc_installation_collector()

  collect_msvc_installations_from_dirs(add_installation)

  each_async(collect_vswhere_candidates(), function(vswhere_path, next_item)
    system_text_async({
      vswhere_path,
      "-products",
      "*",
      "-requires",
      "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
      "-format",
      "json",
      "-utf8",
    }, function(result)
      if result.code == 0 then
        for _, installation in ipairs(parse_vswhere_output(result.stdout or "")) do
          add_installation(installation)
        end
      end

      next_item()
    end)
  end, function()
    table.sort(installations, function(left, right)
      return (left.installationPath or "") < (right.installationPath or "")
    end)

    if type(on_complete) == "function" then
      on_complete(installations)
    end
  end)
end

local function get_latest_msvc_toolchain(installation_path)
  local tools_dir = vim.fs.joinpath(installation_path, "VC", "Tools", "MSVC")
  if not is_existing_dir(tools_dir) then
    return nil, nil
  end

  local versions = {}
  for name, entry_type in vim.fs.dir(tools_dir) do
    if entry_type == "directory" then
      table.insert(versions, name)
    end
  end

  table.sort(versions, compare_version_strings)
  local version = versions[1]
  if not version then
    return nil, nil
  end

  return vim.fs.joinpath(tools_dir, version), version
end

local function get_msvc_setup_script(installation_path, arch)
  local vsdevcmd = vim.fs.joinpath(installation_path, "Common7", "Tools", "VsDevCmd.bat")
  if is_existing_file(vsdevcmd) then
    return vsdevcmd, arch.vsdevcmd_args
  end

  local vcvarsall = vim.fs.joinpath(installation_path, "VC", "Auxiliary", "Build", "vcvarsall.bat")
  if is_existing_file(vcvarsall) then
    return vcvarsall, arch.vcvarsall_args
  end

  local fallback = arch.label == "x86"
      and vim.fs.joinpath(installation_path, "VC", "Auxiliary", "Build", "vcvars32.bat")
    or vim.fs.joinpath(installation_path, "VC", "Auxiliary", "Build", "vcvars64.bat")

  if is_existing_file(fallback) then
    return fallback, {}
  end

  return nil, nil
end

local function build_batch_command(script_path, script_args)
  local command = string.format('call "%s"', script_path:gsub("/", "\\"))
  local args = table.concat(trim_lines(script_args or {}), " ")
  if args ~= "" then
    command = command .. " " .. args
  end

  return command .. " >nul && set"
end

local function capture_batch_environment_sync(script_path, script_args)
  local command = config.msvc_command or vim.env.ComSpec or "cmd.exe"
  local output = read_command_output { command, "/d", "/s", "/c", build_batch_command(script_path, script_args) }
  if not output then
    return nil
  end

  return environment_delta_from_text(table.concat(output, "\n"))
end

local function capture_batch_environment_async(script_path, script_args, on_complete)
  local command = config.msvc_command or vim.env.ComSpec or "cmd.exe"
  system_text_async({ command, "/d", "/s", "/c", build_batch_command(script_path, script_args) }, function(result)
    if type(on_complete) == "function" then
      if result.code == 0 then
        on_complete(environment_delta_from_text(result.stdout or ""))
      else
        on_complete(nil)
      end
    end
  end)
end

local function build_msvc_name(installation, tool_version, arch)
  local prefix = installation.displayName and vim.trim(installation.displayName) or "Visual Studio"
  return string.format("%s MSVC %s (%s)", prefix, tool_version, arch.label)
end

local function make_msvc_candidate(installation, toolchain_root, tool_version, arch, has_ninja, environment_variables)
  local compiler_path = vim.fs.joinpath(toolchain_root, "bin", arch.compiler_subdir, "cl.exe")
  if not is_existing_file(compiler_path) or not environment_variables or vim.tbl_isempty(environment_variables) then
    return nil
  end

  return {
    family = "msvc",
    dir = vim.fs.dirname(compiler_path),
    C = compiler_path,
    CXX = compiler_path,
    version = tool_version,
    name_hint = build_msvc_name(installation, tool_version, arch),
    description = installation.displayName or installation.installationPath,
    environmentVariables = environment_variables,
    generator = has_ninja and config.prefer_ninja and "Ninja" or "NMake Makefiles",
  }
end

local function discover_msvc_candidates_sync(has_ninja)
  if not require("util.os").is_windows() then
    return {}
  end

  local candidates = {}

  for _, installation in ipairs(discover_msvc_installations_sync()) do
    local toolchain_root, tool_version = get_latest_msvc_toolchain(installation.installationPath)
    if toolchain_root and tool_version then
      for _, arch in ipairs(msvc_architectures) do
        local script_path, script_args = get_msvc_setup_script(installation.installationPath, arch)
        if script_path then
          local environment_variables = capture_batch_environment_sync(script_path, script_args)
          local candidate =
            make_msvc_candidate(installation, toolchain_root, tool_version, arch, has_ninja, environment_variables)
          if candidate then
            table.insert(candidates, candidate)
          end
        end
      end
    end
  end

  sort_candidates(candidates)
  return candidates
end

local function discover_msvc_candidates_async(has_ninja, session, on_complete)
  if not require("util.os").is_windows() then
    if type(on_complete) == "function" then
      on_complete {}
    end
    return
  end

  discover_msvc_installations_async(function(installations)
    local candidates = {}

    each_async(installations, function(installation, next_installation)
      local toolchain_root, tool_version = get_latest_msvc_toolchain(installation.installationPath)
      if not toolchain_root or not tool_version then
        next_installation()
        return
      end

      log_scan_progress(
        session,
        string.format("Visual Studio -> %s", installation.displayName or installation.installationPath)
      )

      each_async(msvc_architectures, function(arch, next_architecture)
        local script_path, script_args = get_msvc_setup_script(installation.installationPath, arch)
        if not script_path then
          next_architecture()
          return
        end

        capture_batch_environment_async(script_path, script_args, function(environment_variables)
          local candidate =
            make_msvc_candidate(installation, toolchain_root, tool_version, arch, has_ninja, environment_variables)

          if candidate then
            table.insert(candidates, candidate)
            log_scan_progress(session, string.format("MSVC -> %s", candidate.name_hint))
          end

          next_architecture()
        end)
      end, next_installation)
    end, function()
      sort_candidates(candidates)
      if type(on_complete) == "function" then
        on_complete(candidates)
      end
    end)
  end)
end

local function collect_platform_search_dirs()
  local os = require "util.os"
  local dirs = {}

  if os.is_macos() and config.use_macos_default_search_dirs ~= false then
    append_scan_dir_candidates(dirs, {
      "/opt/homebrew/bin",
      "/usr/local/bin",
      "/Library/Developer/CommandLineTools/usr/bin",
      "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin",
    })
  end

  if os.is_windows() then
    if config.use_mingw_default_search_dirs ~= false then
      append_scan_dir_candidates(dirs, {
        "C:/MinGW/bin",
        "C:/msys64/mingw64/bin",
        "C:/msys64/mingw32/bin",
        "C:/msys64/clang64/bin",
        "C:/msys64/clang32/bin",
        "C:/msys64/clangarm64/bin",
        "C:/msys64/ucrt64/bin",
      })
    end

    append_scan_dir_candidates(dirs, config.mingw_search_dirs)
  end

  return dirs
end

local function collect_search_dirs()
  local dirs = split_env_path(vim.env.PATH or "")

  append_scan_dir_candidates(dirs, config.additional_search_dirs)
  append_scan_dir_candidates(dirs, config.additional_compiler_search_dirs)

  for _, dir in ipairs(collect_platform_search_dirs()) do
    table.insert(dirs, dir)
  end

  return unique_dirs(dirs)
end

read_command_output = function(argv)
  local output = vim.fn.systemlist(argv)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

system_text_async = function(argv, callback)
  if type(vim.system) ~= "function" then
    vim.schedule(function()
      local output = read_command_output(argv)
      callback {
        code = output and 0 or 1,
        stdout = output and table.concat(output, "\n") or "",
        stderr = "",
      }
    end)
    return
  end

  vim.system(argv, { text = true }, vim.schedule_wrap(callback))
end

local function read_json_file(path)
  local normalized = normalize_dir(path)
  if not normalized or vim.uv.fs_stat(normalized) == nil then
    return {}
  end

  local ok, lines = pcall(vim.fn.readfile, normalized)
  if not ok then
    return {}
  end

  local content = table.concat(lines, "\n")
  if vim.trim(content) == "" then
    return {}
  end

  return decode_json_text(content)
end

local function write_kits_file(path, kits)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ vim.json.encode(kits) }, path)
end

local function ensure_user_local_kits_file()
  local path = generated_kits_path()
  if vim.uv.fs_stat(path) == nil then
    write_kits_file(path, {})
  end

  return path
end

local function get_project_local_kits_path(cwd)
  local dir = normalize_dir(cwd)
  if not dir then
    return nil
  end

  for _, name in ipairs { "cmake-kits.json", "CMakeKits.json" } do
    local path = vim.fs.joinpath(dir, name)
    if vim.uv.fs_stat(path) ~= nil then
      return path
    end
  end

  return nil
end

local function is_supported_compiler_suffix(suffix)
  return suffix == "" or suffix:match "^%-%d[%w%.%-]*$" ~= nil
end

local function classify_compiler(name)
  local prefix, suffix = name:match "^(.-)clang%+%+([%w%._-]*)$"
  if prefix ~= nil and is_supported_compiler_suffix(suffix) then
    return {
      family = "clang",
      language = "CXX",
      prefix = prefix,
      suffix = suffix,
      partner = prefix .. "clang" .. suffix,
    }
  end

  prefix, suffix = name:match "^(.-)clang([%w%._-]*)$"
  if prefix ~= nil and is_supported_compiler_suffix(suffix) then
    return {
      family = "clang",
      language = "C",
      prefix = prefix,
      suffix = suffix,
      partner = prefix .. "clang++" .. suffix,
    }
  end

  prefix, suffix = name:match "^(.-)g%+%+([%w%._-]*)$"
  if prefix ~= nil and is_supported_compiler_suffix(suffix) then
    return {
      family = "gcc",
      language = "CXX",
      prefix = prefix,
      suffix = suffix,
      partner = prefix .. "gcc" .. suffix,
    }
  end

  prefix, suffix = name:match "^(.-)gcc([%w%._-]*)$"
  if prefix ~= nil and is_supported_compiler_suffix(suffix) then
    return {
      family = "gcc",
      language = "C",
      prefix = prefix,
      suffix = suffix,
      partner = prefix .. "g++" .. suffix,
    }
  end

  return nil
end

local function compiler_key(classification)
  return table.concat({ classification.family, classification.prefix, classification.suffix }, "|")
end

local function scan_directory(dir, state)
  local entries = {}
  local interesting = {}

  for name, entry_type in vim.fs.dir(dir) do
    if entry_type == "file" or entry_type == "link" then
      local classification = classify_compiler(name)
      local is_ninja = name == "ninja" or name:match "^ninja%.exe$"

      if classification or is_ninja then
        local path = vim.fs.joinpath(dir, name)
        if vim.fn.executable(path) == 1 then
          entries[name] = path
          table.insert(interesting, name)
          if is_ninja then
            state.has_ninja = true
          end
        end
      end
    end
  end

  table.sort(interesting)

  for name, path in pairs(entries) do
    local classification = classify_compiler(name)
    if classification and entries[classification.partner] then
      local key = compiler_key(classification)
      local candidate = state.candidates[key]
        or {
          family = classification.family,
          prefix = classification.prefix,
          suffix = classification.suffix,
          dir = dir,
        }

      candidate[classification.language] = path
      state.candidates[key] = candidate
    end
  end

  return interesting
end

local function canonicalize_compiler(path)
  return vim.uv.fs_realpath(path) or path
end

local function build_candidate_list(state)
  local seen_pairs = {}
  local candidates = {}

  for _, candidate in pairs(state.candidates) do
    if candidate.C and candidate.CXX then
      local canonical_c = canonicalize_compiler(candidate.C)
      local canonical_cxx = canonicalize_compiler(candidate.CXX)
      local pair_key = table.concat({ canonical_c, canonical_cxx }, "|")
      if not seen_pairs[pair_key] then
        seen_pairs[pair_key] = true
        table.insert(candidates, {
          family = candidate.family,
          prefix = candidate.prefix,
          suffix = candidate.suffix,
          dir = candidate.dir,
          C = canonical_c,
          CXX = canonical_cxx,
        })
      end
    end
  end

  sort_candidates(candidates)

  return candidates
end

local function detect_gcc_version(compiler_path)
  local version_lines = read_command_output { compiler_path, "-dumpfullversion", "-dumpversion" }
  if version_lines then
    local version = vim.trim(table.concat(version_lines, "\n"))
    if version ~= "" then
      return version
    end
  end

  local output = read_command_output { compiler_path, "--version" }
  if not output or not output[1] then
    return "unknown"
  end

  return output[1]:match "(%d[%w%._-]+)" or "unknown"
end

local function detect_clang_version(compiler_path)
  local output = read_command_output { compiler_path, "--version" }
  if not output or not output[1] then
    return "unknown"
  end

  return output[1]:match "clang version%s+([%w%._-]+)" or output[1]:match "(%d[%w%._-]+)" or "unknown"
end

local function detect_version(family, compiler_path)
  if family == "gcc" then
    return detect_gcc_version(compiler_path)
  elseif family == "msvc" then
    return "unknown"
  end

  return detect_clang_version(compiler_path)
end

local function detect_gcc_version_async(compiler_path, callback)
  system_text_async({ compiler_path, "-dumpfullversion", "-dumpversion" }, function(result)
    if result.code == 0 then
      local version = vim.trim(result.stdout or "")
      if version ~= "" then
        callback(version)
        return
      end
    end

    system_text_async({ compiler_path, "--version" }, function(fallback)
      local first_line = split_lines(fallback.stdout)[1]
      callback(first_line and (first_line:match "(%d[%w%._-]+)" or "unknown") or "unknown")
    end)
  end)
end

local function detect_clang_version_async(compiler_path, callback)
  system_text_async({ compiler_path, "--version" }, function(result)
    local first_line = split_lines(result.stdout)[1]
    callback(
      first_line and (first_line:match "clang version%s+([%w%._-]+)" or first_line:match "(%d[%w%._-]+)" or "unknown")
        or "unknown"
    )
  end)
end

local function detect_version_async(family, compiler_path, callback)
  if family == "gcc" then
    detect_gcc_version_async(compiler_path, callback)
    return
  elseif family == "msvc" then
    callback "unknown"
    return
  end

  detect_clang_version_async(compiler_path, callback)
end

local function ensure_unique_name(base_name, compiler_dir, used_names)
  if not used_names[base_name] then
    used_names[base_name] = true
    return base_name
  end

  local with_dir = base_name .. " (" .. vim.fs.basename(compiler_dir) .. ")"
  if not used_names[with_dir] then
    used_names[with_dir] = true
    return with_dir
  end

  local suffix = 2
  local candidate = with_dir .. " #" .. suffix
  while used_names[candidate] do
    suffix = suffix + 1
    candidate = with_dir .. " #" .. suffix
  end

  used_names[candidate] = true
  return candidate
end

local function build_kit(candidate, has_ninja, used_names)
  if not candidate.C or not candidate.CXX then
    return nil
  end

  local compiler_dir = vim.fs.dirname(candidate.C)
  local version = candidate.version or detect_version(candidate.family, candidate.CXX)
  local base_name = candidate.name_hint

  if not base_name then
    local vendor = candidate.family == "gcc" and "GCC" or candidate.family == "msvc" and "MSVC" or "Clang"
    local prefix = candidate.prefix and candidate.prefix:gsub("-$", "") or ""
    base_name = vendor .. " " .. version
    if prefix ~= "" then
      base_name = prefix .. " " .. base_name
    end
  end

  local kit = {
    name = ensure_unique_name(base_name, compiler_dir, used_names),
    description = candidate.description or compiler_dir,
    generator = candidate.generator,
    compilers = {
      C = candidate.C,
      CXX = candidate.CXX,
    },
  }

  if kit.generator == nil and has_ninja and config.prefer_ninja then
    kit.generator = "Ninja"
  end

  if candidate.linker then
    kit.linker = candidate.linker
  end

  if candidate.toolchainFile then
    kit.toolchainFile = candidate.toolchainFile
  end

  if candidate.environmentSetupScript then
    kit.environmentSetupScript = candidate.environmentSetupScript
  end

  if candidate.environmentVariables then
    kit.environmentVariables = candidate.environmentVariables
  end

  if candidate.cmakeSettings then
    kit.cmakeSettings = candidate.cmakeSettings
  end

  if candidate.host_architecture then
    kit.host_architecture = candidate.host_architecture
  end

  if candidate.target_architecture then
    kit.target_architecture = candidate.target_architecture
  end

  return kit
end

local function sort_kits(kits)
  table.sort(kits, function(left, right)
    return (left.name or "") < (right.name or "")
  end)
end

local function is_compiler_based_kit(kit)
  return type(kit) == "table" and type(kit.compilers) == "table" and next(kit.compilers) ~= nil
end

local function merge_scanned_kits(scanned_kits)
  local existing = read_json_file(generated_kits_path())
  local merged = {}
  local preserved = {}
  local seen = {}

  for _, kit in ipairs(existing) do
    if type(kit) == "table" then
      local preserve = kit.keep == true or not is_compiler_based_kit(kit)
      if preserve and kit.name and not seen[kit.name] then
        seen[kit.name] = true
        table.insert(merged, kit)
        table.insert(preserved, kit)
      end
    end
  end

  for _, kit in ipairs(scanned_kits) do
    if kit.name and not seen[kit.name] then
      seen[kit.name] = true
      table.insert(merged, kit)
    end
  end

  sort_kits(merged)
  return merged, preserved
end

local function create_report_buffer()
  local bufnr = ui_state.report_bufnr
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr
  end

  bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, "cmake-tools://kits")
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "markdown"
  vim.bo[bufnr].modifiable = false

  ui_state.report_bufnr = bufnr
  return bufnr
end

local function open_report_buffer()
  local bufnr = create_report_buffer()
  if #vim.api.nvim_list_uis() == 0 then
    return bufnr
  end

  local winid = vim.fn.bufwinid(bufnr)
  if winid ~= -1 then
    return bufnr
  end

  local previous_win = vim.api.nvim_get_current_win()
  vim.cmd "botright 15split"
  local report_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(report_win, bufnr)
  if vim.api.nvim_win_is_valid(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
  end

  return bufnr
end

local function set_report_lines(title, lines)
  local bufnr = open_report_buffer()
  local content = { "# " .. title, "" }
  vim.list_extend(content, lines)

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
  vim.bo[bufnr].modifiable = false
end

local function append_field(lines, label, value, indent)
  indent = indent or ""
  if value == nil then
    return
  end

  if type(value) == "table" then
    table.insert(lines, indent .. label .. ":")
    for _, line in ipairs(split_lines(vim.inspect(value))) do
      table.insert(lines, indent .. "  " .. line)
    end
    return
  end

  table.insert(lines, indent .. label .. ": " .. tostring(value))
end

local function format_kits_report_lines(kits, metadata, opts)
  metadata = metadata or {}
  opts = opts or {}
  local lines = {}

  append_field(lines, "Path", metadata.path)
  append_field(lines, "Status", metadata.status)
  append_field(lines, "Total kits", #kits)
  append_field(lines, "Scanned kits", metadata.scanned_count)
  append_field(lines, "Preserved kits", metadata.preserved_count)
  append_field(lines, "Search dirs", metadata.search_dir_count)

  if metadata.instructions and #metadata.instructions > 0 then
    table.insert(lines, "")
    for _, instruction in ipairs(metadata.instructions) do
      table.insert(lines, instruction)
    end
  end

  table.insert(lines, "")

  if #kits == 0 then
    table.insert(lines, "No kits available.")
    return lines
  end

  if not opts.verbose then
    for index, kit in ipairs(kits) do
      table.insert(lines, string.format("[%d] %s", index, M.format_selection_item(kit, { verbose = false })))
    end
    return lines
  end

  for index, kit in ipairs(kits) do
    local seen = {
      name = true,
      description = true,
      generator = true,
      preferredGenerator = true,
      compilers = true,
      toolchainFile = true,
      environmentSetupScript = true,
      environmentVariables = true,
      cmakeSettings = true,
      keep = true,
    }

    table.insert(lines, string.format("[%d] %s", index, kit.name or "<unnamed>"))
    append_field(lines, "description", kit.description, "  ")
    append_field(lines, "generator", kit.generator, "  ")
    append_field(lines, "preferredGenerator", kit.preferredGenerator, "  ")
    append_field(lines, "toolchainFile", kit.toolchainFile, "  ")
    append_field(lines, "keep", kit.keep, "  ")
    append_field(lines, "compilers", kit.compilers, "  ")
    append_field(lines, "environmentSetupScript", kit.environmentSetupScript, "  ")
    append_field(lines, "environmentVariables", kit.environmentVariables, "  ")
    append_field(lines, "cmakeSettings", kit.cmakeSettings, "  ")

    local extra_keys = {}
    for key in pairs(kit) do
      if not seen[key] then
        table.insert(extra_keys, key)
      end
    end
    table.sort(extra_keys)

    for _, key in ipairs(extra_keys) do
      append_field(lines, key, kit[key], "  ")
    end

    table.insert(lines, "")
  end

  return lines
end

render_scan_progress = function(session)
  if not session.verbose then
    return
  end

  local lines = {}

  append_field(lines, "Path", session.path)
  append_field(lines, "Status", session.status)
  append_field(lines, "Search dirs", #session.search_dirs)
  append_field(lines, "Scanned dirs", string.format("%d/%d", session.scanned_dirs or 0, #session.search_dirs))
  append_field(lines, "Compiler pairs", session.total_candidates)
  if session.total_candidates and session.total_candidates > 0 then
    append_field(
      lines,
      "Resolved versions",
      string.format("%d/%d", session.completed_candidates or 0, session.total_candidates)
    )
  end

  table.insert(lines, "")

  if #session.logs > 0 then
    table.insert(lines, "Progress:")
    for _, item in ipairs(session.logs) do
      table.insert(lines, "- " .. item)
    end
  else
    table.insert(lines, "Waiting for compiler scan results...")
  end

  set_report_lines("CMake Kit Scan", lines)
end

local function build_scanned_kits(candidates, has_ninja)
  local used_names = {}
  local kits = {}

  for _, candidate in ipairs(candidates) do
    local kit = build_kit(candidate, has_ninja, used_names)
    if kit then
      table.insert(kits, kit)
    end
  end

  sort_kits(kits)
  return kits
end

local function finish_scan(session, candidates, has_ninja, on_complete)
  local scanned_kits = build_scanned_kits(candidates, has_ninja)
  local merged_kits, preserved_kits = merge_scanned_kits(scanned_kits)
  local path = ensure_user_local_kits_file()
  write_kits_file(path, merged_kits)

  local result = {
    kits = merged_kits,
    scanned_kits = scanned_kits,
    preserved_kits = preserved_kits,
    path = path,
  }

  if session.verbose then
    set_report_lines(
      "CMake Kits",
      format_kits_report_lines(merged_kits, {
        path = path,
        status = "Scan complete",
        scanned_count = #scanned_kits,
        preserved_count = #preserved_kits,
        search_dir_count = #session.search_dirs,
        instructions = {
          "Use :CMakeKits select to choose a kit for the current project.",
          "Use :CMakeKits edit to edit the user-local kits JSON.",
          "Set keep = true on a kit entry if you do not want future scans to replace it.",
        },
      }, {
        verbose = true,
      })
    )
  end

  if type(on_complete) == "function" then
    on_complete(result)
  end
end

function M.get_path()
  return generated_kits_path()
end

function M.get_search_dirs()
  return collect_search_dirs()
end

function M.has_project_local_kits(cwd)
  return get_project_local_kits_path(cwd) ~= nil
end

function M.read_user_local_kits()
  return read_json_file(ensure_user_local_kits_file())
end

function M.read_effective_kits(cwd)
  local project_path = get_project_local_kits_path(cwd or vim.loop.cwd())
  if project_path then
    return read_json_file(project_path), project_path
  end

  local path = ensure_user_local_kits_file()
  return read_json_file(path), path
end

function M.format_selection_item(kit, opts)
  opts = opts or {}
  local parts = { kit.name or "<unnamed>" }
  local generator = kit.generator or kit.preferredGenerator
  if generator then
    table.insert(parts, "generator=" .. generator)
  end
  if kit.description then
    table.insert(parts, kit.description)
  end
  if opts.verbose and type(kit.compilers) == "table" then
    local compilers = {}
    if kit.compilers.C then
      table.insert(compilers, "C=" .. kit.compilers.C)
    end
    if kit.compilers.CXX then
      table.insert(compilers, "CXX=" .. kit.compilers.CXX)
    end
    if #compilers > 0 then
      table.insert(parts, table.concat(compilers, " "))
    end
  end

  return table.concat(parts, " | ")
end

function M.show_effective_kits(cwd, opts)
  opts = opts or {}
  local kits, path = M.read_effective_kits(cwd)
  set_report_lines(
    "CMake Kits",
    format_kits_report_lines(kits, {
      path = path,
      status = "Effective kits for current project",
      instructions = {
        "This list is what :CMakeKits select will use for the current working directory.",
      },
    }, {
      verbose = opts.verbose == true,
    })
  )
  return kits, path
end

function M.edit_user_local_kits()
  local path = ensure_user_local_kits_file()
  vim.cmd.edit(vim.fn.fnameescape(path))
  return path
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
end

function M.scan()
  local state = {
    candidates = {},
    has_ninja = false,
  }

  for _, dir in ipairs(collect_search_dirs()) do
    scan_directory(dir, state)
  end

  local candidates = build_candidate_list(state)
  vim.list_extend(candidates, discover_msvc_candidates_sync(state.has_ninja))
  sort_candidates(candidates)

  for _, candidate in ipairs(candidates) do
    if not candidate.version then
      candidate.version = detect_version(candidate.family, candidate.CXX)
    end
  end

  local scanned_kits = build_scanned_kits(candidates, state.has_ninja)
  local merged_kits, preserved_kits = merge_scanned_kits(scanned_kits)
  local path = ensure_user_local_kits_file()
  write_kits_file(path, merged_kits)

  return {
    kits = merged_kits,
    scanned_kits = scanned_kits,
    preserved_kits = preserved_kits,
    path = path,
  }
end

function M.scan_async(opts, on_complete)
  if type(opts) == "function" then
    on_complete = opts
    opts = {}
  end

  opts = opts or {}

  local raw_state = {
    candidates = {},
    has_ninja = false,
  }

  local session = {
    path = generated_kits_path(),
    status = "Scanning PATH directories",
    search_dirs = collect_search_dirs(),
    scanned_dirs = 0,
    total_candidates = 0,
    completed_candidates = 0,
    logs = {},
    verbose = opts.verbose == true,
  }

  render_scan_progress(session)

  local dir_index = 1
  local scan_batch_size = math.max(1, tonumber(config.scan_batch_size) or 1)

  local function resolve_candidate_versions(candidates)
    session.total_candidates = #candidates

    if #candidates == 0 then
      session.status = "No compiler pairs found"
      render_scan_progress(session)
      finish_scan(session, candidates, raw_state.has_ninja, on_complete)
      return
    end

    session.status = "Resolving compiler versions asynchronously"
    render_scan_progress(session)

    local remaining = #candidates
    for _, candidate in ipairs(candidates) do
      detect_version_async(candidate.family, candidate.CXX, function(version)
        candidate.version = version or "unknown"
        session.completed_candidates = session.completed_candidates + 1
        if session.verbose then
          table.insert(
            session.logs,
            string.format(
              "[%d/%d] %s -> %s",
              session.completed_candidates,
              session.total_candidates,
              candidate.CXX,
              candidate.version
            )
          )
        end
        render_scan_progress(session)

        remaining = remaining - 1
        if remaining == 0 then
          session.status = "Writing user-local kits file"
          render_scan_progress(session)
          finish_scan(session, candidates, raw_state.has_ninja, on_complete)
        end
      end)
    end
  end

  local function scan_next_batch()
    local processed = 0
    while dir_index <= #session.search_dirs and processed < scan_batch_size do
      local dir = session.search_dirs[dir_index]
      local interesting = scan_directory(dir, raw_state)
      if session.verbose and #interesting > 0 then
        table.insert(session.logs, string.format("%s -> %s", dir, table.concat(interesting, ", ")))
      end

      session.scanned_dirs = dir_index
      dir_index = dir_index + 1
      processed = processed + 1
    end

    render_scan_progress(session)

    if dir_index <= #session.search_dirs then
      vim.schedule(scan_next_batch)
      return
    end

    session.status = "Discovering Visual Studio toolchains"
    render_scan_progress(session)

    discover_msvc_candidates_async(raw_state.has_ninja, session, function(msvc_candidates)
      local candidates = build_candidate_list(raw_state)
      vim.list_extend(candidates, msvc_candidates)
      sort_candidates(candidates)
      resolve_candidate_versions(candidates)
    end)
  end

  vim.schedule(scan_next_batch)
end

return M
