---@type LazyPluginSpec
local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000, -- needs to be loaded in first
}

local function dedupe_diagnostics(diagnostics)
  local seen = {}
  local deduped = {}

  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message and diagnostic.message:gsub("%s+", " ") or ""
    local key = table.concat({
      diagnostic.lnum or -1,
      diagnostic.col or -1,
      diagnostic.end_lnum or -1,
      diagnostic.end_col or -1,
      diagnostic.severity or -1,
      diagnostic.source or "",
      message,
      diagnostic.is_related and 1 or 0,
    }, "|")

    if not seen[key] then
      seen[key] = true
      table.insert(deduped, diagnostic)
    end
  end

  return deduped
end

M.config = function()
  local filter = require "tiny-inline-diagnostic.filter"

  if not filter._dedupe_wrapped then
    local original_for_display = filter.for_display

    filter.for_display = function(opts, bufnr, diagnostics)
      return dedupe_diagnostics(original_for_display(opts, bufnr, diagnostics))
    end

    filter._dedupe_wrapped = true
  end

  require("tiny-inline-diagnostic").setup {
    preset = "modern",
    options = {
      show_source = {
        enabled = true,
        if_many = true,
      },
      show_related = false,
      use_icons_from_diagnostic = true,
      show_diags_only_under_cursor = true,
      multilines = {
        enabled = true,
        always_show = false,
      },
      enable_on_insert = false,
      enable_on_select = false,
    },
    disabled_ft = {},
  }
  vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
end

return M
