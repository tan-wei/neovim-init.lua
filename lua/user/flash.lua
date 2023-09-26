local status_ok, flash = pcall(require, "flash")
if not status_ok then
  return
end

flash.setup {
  search = {
    exclude = {
      "notify",
      "cmp_menu",
      "noice",
      "flash_prompt",
      function(win)
        return not vim.api.nvim_win_get_config(win).focusable
      end,
      "NvimTree",
    },
  },
}
