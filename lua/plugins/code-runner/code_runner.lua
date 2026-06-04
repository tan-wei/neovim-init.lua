---@type LazyPluginSpec
local M = {
  "CRAG666/code_runner.nvim",
  cmd = {
    "RunCode",
    "RunFile",
    "RunProject",
    "RunClose",
    "CRFiletype",
    "CRProjects",
  },
}

local os_util = require "util.os"
local provider = require "util.provider"

local function compact_map(tbl)
  local ret = {}
  for key, value in pairs(tbl) do
    if value ~= nil then
      ret[key] = value
    end
  end
  return ret
end

local function get_command_binary(command)
  if type(command) ~= "string" then
    return nil
  end

  local parts = vim.split(vim.trim(command), "%s+", { trimempty = true })
  return parts[1]
end

local function command_exists(command)
  local binary = get_command_binary(command)
  return binary ~= nil and provider.executable_exist(binary)
end

local function pick_command(candidates)
  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" and command_exists(candidate) then
      return candidate
    end
  end
  return nil
end

local function interpreter_command(candidates, suffix)
  local command = pick_command(candidates)
  if not command then
    return nil
  end

  if suffix and suffix ~= "" then
    return string.format("%s %s", command, suffix)
  end

  return command
end

local function build_vimscript_runner()
  local progpath = vim.fn.shellescape(vim.v.progpath)

  return function()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
      return nil
    end

    local source_cmd = vim.fn.shellescape("source " .. vim.fn.fnameescape(file))
    return string.format("%s --clean -u NONE --headless -c %s -c qa$end", progpath, source_cmd)
  end
end

local function compiled_output_path(filetype)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end

  local cache_dir = vim.fs.joinpath(vim.fn.stdpath "cache", "code_runner", filetype)
  vim.fn.mkdir(cache_dir, "p")

  local suffix = os_util.is_windows() and ".exe" or ""
  local stem = file:gsub("[:/\\]", "__")
  return vim.fs.joinpath(cache_dir, stem .. suffix)
end

local function compiler_candidates(filetype)
  local candidates = { filetype == "c" and os.getenv "CC" or os.getenv "CXX" }

  if filetype == "c" then
    if os_util.is_windows() then
      vim.list_extend(candidates, { "clang", "gcc", "cl", "clang-cl", "zig cc" })
    else
      vim.list_extend(candidates, { "cc", "clang", "gcc", "zig cc" })
    end
  elseif os_util.is_windows() then
    vim.list_extend(candidates, { "clang++", "g++", "cl", "clang-cl", "zig c++" })
  else
    vim.list_extend(candidates, { "c++", "clang++", "g++", "zig c++" })
  end

  return candidates
end

local function compiler_flags(filetype)
  local env_name = filetype == "c" and "CFLAGS" or "CXXFLAGS"
  local flags = os.getenv(env_name)
  if not flags or flags == "" then
    return ""
  end
  return " " .. flags
end

local function is_msvc_like(command)
  local binary = get_command_binary(command)
  if not binary then
    return false
  end

  local name = vim.fs.basename(binary):lower()
  return name == "cl" or name == "cl.exe" or name == "clang-cl" or name == "clang-cl.exe"
end

local function build_native_runner(filetype)
  return function()
    local compiler = pick_command(compiler_candidates(filetype))
    local file = vim.api.nvim_buf_get_name(0)
    if not compiler or file == "" then
      return nil
    end

    local cwd = vim.fn.shellescape(vim.fs.dirname(file))
    local input = vim.fn.shellescape(vim.fn.fnamemodify(file, ":t"))
    local output = compiled_output_path(filetype)
    if not output then
      return nil
    end

    local output_escaped = vim.fn.shellescape(output)
    local flags = compiler_flags(filetype)

    if is_msvc_like(compiler) then
      local extra = filetype == "cpp" and " /EHsc" or ""
      return string.format(
        "cd %s && %s /nologo%s%s %s /Fe:%s && %s$end",
        cwd,
        compiler,
        extra,
        flags,
        input,
        output_escaped,
        output_escaped
      )
    end

    return string.format(
      "cd %s && %s%s %s -o %s && %s$end",
      cwd,
      compiler,
      flags,
      input,
      output_escaped,
      output_escaped
    )
  end
end

local function find_csproj_root()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()

  while dir and dir ~= "" do
    local matches = vim.fn.glob(vim.fs.joinpath(dir, "*.csproj"), false, true)
    if type(matches) == "table" and #matches > 0 then
      return dir
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
end

M.config = function()
  local filetype_commands = compact_map {
    javascript = interpreter_command { "node", "bun", "deno run" },
    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
    kotlin = "cd $dir && kotlinc-native $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt.kexe",
    c = build_native_runner "c",
    cpp = build_native_runner "cpp",
    go = interpreter_command { "go run" },
    lua = interpreter_command { "luajit", "lua" },
    perl = interpreter_command { "perl" },
    php = interpreter_command { "php" },
    python = interpreter_command({ "python", "python3" }, "-u"),
    ruby = interpreter_command { "ruby" },
    r = interpreter_command { "Rscript" },
    sh = interpreter_command { "bash", "sh" },
    bash = interpreter_command { "bash" },
    zsh = interpreter_command { "zsh" },
    fish = interpreter_command { "fish" },
    typescript = interpreter_command { "deno run", "tsx", "ts-node", "bun run" },
    typescriptreact = "yarn dev$end",
    rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
    dart = interpreter_command { "dart" },
    vim = build_vimscript_runner(),
    cs = function(...)
      local root_dir = find_csproj_root()
      return "cd " .. vim.fn.shellescape(root_dir) .. " && dotnet run$end"
    end,
  }

  require("code_runner").setup {
    mode = "term",
    focus = true,
    filetype = filetype_commands,
    -- project_path = vim.fn.expand "~/.config/nvim/project_manager.json",
  }
end

return M
