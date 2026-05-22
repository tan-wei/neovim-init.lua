---@type LazyPluginSpec
local M = {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
}

local lint_specs = {
  clangtidy = {
    executable = "clang-tidy",
    filetypes = { "c", "cpp" },
  },
  cppcheck = {
    executable = "cppcheck",
    filetypes = { "c", "cpp" },
  },
  cpplint = {
    executable = "cpplint",
    filetypes = { "c", "cpp" },
  },
  dotenv_linter = {
    executable = "dotenv-linter",
    filetypes = { "envfile" },
  },
}

local function enabled_linter_set(linters_by_ft)
  local enabled = {}

  for _, linters in pairs(linters_by_ft) do
    for _, linter_name in ipairs(linters) do
      enabled[linter_name] = true
    end
  end

  return enabled
end

local function clear_disabled_diagnostics(lint, linters_by_ft)
  local enabled = enabled_linter_set(linters_by_ft)

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
      for linter_name in pairs(lint_specs) do
        if not enabled[linter_name] then
          vim.diagnostic.reset(lint.get_namespace(linter_name), bufnr)
        end
      end
    end
  end
end

local function get_project_linters()
  local ok, config_local = pcall(require, "config-local")

  if not ok or not config_local.lookup or not config_local.lookup() then
    return {}
  end

  if type(vim.g.linters) ~= "table" then
    return {}
  end

  return vim.g.linters
end

local function build_linters_by_ft()
  local provider = require "util.provider"
  local project_linters = get_project_linters()
  local linters_by_ft = {}

  for linter_name, spec in pairs(lint_specs) do
    local enabled = project_linters[linter_name]

    if enabled == nil then
      enabled = provider.executable_exist(spec.executable)
    else
      enabled = enabled and provider.executable_exist(spec.executable)
    end

    if enabled then
      for _, filetype in ipairs(spec.filetypes) do
        linters_by_ft[filetype] = linters_by_ft[filetype] or {}
        table.insert(linters_by_ft[filetype], linter_name)
      end
    end
  end

  return linters_by_ft
end

local function refresh_linters(lint)
  local linters_by_ft = build_linters_by_ft()

  lint.linters_by_ft = linters_by_ft
  clear_disabled_diagnostics(lint, linters_by_ft)

  return linters_by_ft
end

-- TODO: Add lint progress by require("lint").get_running()
M.config = function()
  local lint = require "lint"

  refresh_linters(lint)

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function()
      refresh_linters(lint)
      lint.try_lint()
    end,
  })

  vim.api.nvim_create_autocmd("DirChangedPre", {
    callback = function()
      vim.g.linters = nil
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "ConfigLocalFinished",
    callback = function()
      refresh_linters(lint)
      lint.try_lint()
    end,
  })
end

return M
