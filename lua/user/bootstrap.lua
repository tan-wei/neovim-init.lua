local treesitter_parsers = require "user.treesitter_parsers"
local mason_packages = require "user.mason_packages"

local M = {}

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
    name = mappings.lspconfig_to_package[name] or mappings.lspconfig_to_mason[name] or name
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
  local missing = list_missing(treesitter_parsers, installed)
  if #missing > 0 then
    error("Missing treesitter parsers: " .. table.concat(missing, ", "))
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
  vim.cmd "silent edit init.lua"
  vim.cmd "silent edit justfile"
  vim.wait(1500, function()
    return false
  end, 50)

  if vim.v.errmsg ~= "" then
    error(vim.v.errmsg)
  end
end

return M
