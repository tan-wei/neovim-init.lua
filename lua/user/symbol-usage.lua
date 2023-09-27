local status_ok, symbol_usage = pcall(require, "symbol-usage")
if not status_ok then
  return
end

symbol_usage.setup {
  hl = { link = "Comment" },
  kinds_filter = {},
  vt_position = "above",
  request_pending_text = "loading...",
  references = { enabled = true, include_declaration = false },
  definition = { enabled = true },
  implementation = { enabled = true },
  ---@type UserOpts[] See default overridings in `lua/symbol-usage/langs.lua`
  -- filetypes = {},
}
