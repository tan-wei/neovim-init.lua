local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then
  return
end

lspsaga.setup {
  ui = {
    code_action = "",
  },

  symbol_in_winbar = {
    enable = false,
  },
}
