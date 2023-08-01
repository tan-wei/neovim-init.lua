local status_ok, wilder = pcall(require, "wilder")
if not status_ok then
  return
end

wilder.setup {
  modes = { ":", "/", "?" },
  next_key = "<Tab>",
  previous_key = "<S-Tab>",
  accept_key = "<Down>",
  reject_key = "<Up>",
}

wilder.set_option(
  "renderer",
  wilder.popupmenu_renderer {
    highlighter = wilder.basic_highlighter(),
    left = { " ", wilder.popupmenu_devicons() },
    right = { " ", wilder.popupmenu_scrollbar() },
  }
)

local UpdatePlugs = vim.api.nvim_create_augroup("UpdateRemotePlugs", {})
vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
  pattern = "*",
  group = UpdatePlugs,
  command = "runtime! plugin/rplugin.vim",
})
vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
  pattern = "*",
  group = UpdatePlugs,
  command = "silent! UpdateRemotePlugins",
})
