local treesitter_parsers = require "user.treesitter_parsers"
local mason_packages = require "user.mason_packages"

local M = {}

local repo_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local smoke_fixture_dir = vim.fs.joinpath(vim.fn.stdpath "cache", "bootstrap-smoke")

local ignored_smoke_errmsg_by_filetype = {
  -- Ignore the known markdown ftplugin churn until the plugin-side issue is fixed.
  markdown = {
    "^E31: No such mapping$",
  },
}

local function list_missing(expected, actual)
  local seen = {}
  for _, item in ipairs(actual) do
    seen[item] = true
  end

  local missing = {}
  for _, item in ipairs(expected) do
    if not seen[item] then
      table.insert(missing, item)
    end
  end

  table.sort(missing)
  return missing
end

local function map_mason_name(name)
  local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
  if ok_mlsp then
    local mappings = mlsp.get_mappings()
    local lspconfig_to_package = mappings.lspconfig_to_package or mappings.lspconfig_to_mason or {}
    name = lspconfig_to_package[name] or name
  end

  local ok_mdap, mdap = pcall(require, "mason-nvim-dap.mappings.source")
  if ok_mdap then
    name = mdap.nvim_dap_to_package[name] or name
  end

  return name
end

local function mason_ensure_installed()
  local ensure_installed = vim.deepcopy(mason_packages.lsp_servers)
  vim.list_extend(ensure_installed, mason_packages.tools)
  vim.list_extend(ensure_installed, mason_packages.dap_adapters)
  return ensure_installed
end

local function resolved_mason_package_names()
  local resolved = {}
  local seen = {}

  for _, package in ipairs(mason_ensure_installed()) do
    local mapped = map_mason_name(package)
    if not seen[mapped] then
      seen[mapped] = true
      table.insert(resolved, mapped)
    end
  end

  table.sort(resolved)
  return resolved
end

local function refresh_mason_registry()
  local settings = require "mason.settings"
  local registry = require "mason-registry"
  local previous_refresh = settings.current.registry_cache.refresh

  settings.current.registry_cache.refresh = true
  local ok, result = registry.refresh()
  settings.current.registry_cache.refresh = previous_refresh

  if not ok then
    local detail = type(result) == "string" and result or vim.inspect(result)
    error("Mason registry refresh failed: " .. detail)
  end
end

local function write_smoke_fixture(path, lines)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile(lines, path)
end

local function ensure_smoke_fixtures()
  write_smoke_fixture(vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.rs"), {
    "fn main() {",
    '    println!("bootstrap smoke");',
    "}",
  })

  write_smoke_fixture(vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.go"), {
    "package main",
    "",
    "func main() {}",
  })

  write_smoke_fixture(vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.rb"), {
    "puts 'bootstrap smoke'",
  })
end

local function smoke_cases()
  ensure_smoke_fixtures()

  return {
    { path = vim.fs.joinpath(repo_root, "init.lua") },
    { path = vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.rs") },
    { path = vim.fs.joinpath(repo_root, "justfile") },
    { path = vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.go") },
    { path = vim.fs.joinpath(smoke_fixture_dir, "bootstrap-smoke.rb") },
    { path = vim.fs.joinpath(repo_root, "templates", "vim-template", "=template=.c") },
    { path = vim.fs.joinpath(repo_root, "templates", "vim-template", "=template=.cpp") },
    { path = vim.fs.joinpath(repo_root, "README.md") },
  }
end

local function should_ignore_smoke_errmsg(filetype, errmsg)
  local patterns = ignored_smoke_errmsg_by_filetype[filetype]
  if errmsg == "" or not patterns then
    return false
  end

  for _, pattern in ipairs(patterns) do
    if errmsg:match(pattern) then
      return true
    end
  end

  return false
end

function M.treesitter_sync(timeout_ms)
  local ok = require("nvim-treesitter")
    .update(treesitter_parsers, {
      max_jobs = 8,
      summary = true,
    })
    :wait(timeout_ms or 300000)

  if not ok then
    error "nvim-treesitter update timed out or failed"
  end

  local installed = require("nvim-treesitter").get_installed "parsers"

  -- Only check installable parsers (those with install_info) for missing
  local parsers_mod = require "nvim-treesitter.parsers"
  local installable = {}
  for _, p in ipairs(treesitter_parsers) do
    local spec = parsers_mod[p]
    if spec and spec.install_info then
      table.insert(installable, p)
    end
  end
  local missing = list_missing(installable, installed)
  if #missing > 0 then
    error("Missing treesitter parsers: " .. table.concat(missing, ", "))
  end

  -- Remove stale parsers that are no longer in our config
  -- These are installed parsers whose upstream definitions have been removed
  -- from nvim-treesitter, so :TSUninstall won't work — we need to clean up manually.
  local stale = {}
  local config_set = {}
  for _, p in ipairs(treesitter_parsers) do
    config_set[p] = true
  end
  local parser_dir = vim.fs.joinpath(vim.fn.stdpath "data", "site", "parser")
  for _, p in ipairs(installed) do
    if not config_set[p] then
      local so_file = vim.fs.joinpath(parser_dir, p .. ".so")
      local ok, _ = os.remove(so_file)
      if ok then
        table.insert(stale, p)
      end
    end
  end
  if #stale > 0 then
    table.sort(stale)
    print("Cleaned stale parsers: " .. table.concat(stale, ", "))
  end
end

function M.mason_sync()
  local installer = require "mason-tool-installer"
  installer.setup {
    ensure_installed = mason_ensure_installed(),
    auto_update = false,
    run_on_start = false,
    start_delay = 0,
    debounce_hours = nil,
  }

  refresh_mason_registry()
  vim.cmd "MasonToolsInstallSync"

  local registry = require "mason-registry"
  local missing = {}
  for _, package in ipairs(resolved_mason_package_names()) do
    if not registry.is_installed(package) then
      table.insert(missing, package)
    end
  end

  table.sort(missing)
  if #missing > 0 then
    error("Missing Mason packages: " .. table.concat(missing, ", "))
  end
end

function M.startup_smoke()
  for _, case in ipairs(smoke_cases()) do
    vim.v.errmsg = ""
    vim.cmd("silent edit " .. vim.fn.fnameescape(case.path))
    vim.wait(case.wait_ms or 500, function()
      return false
    end, 50)

    local errmsg = vim.v.errmsg
    if errmsg ~= "" and not should_ignore_smoke_errmsg(vim.bo.filetype, errmsg) then
      error(case.path .. ": " .. errmsg)
    end
  end

  vim.v.errmsg = ""
end

return M
