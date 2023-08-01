local status_ok, whitespace = pcall(require, "whitespace-nvim")
if not status_ok then
  return
end

whitespace.setup {
  -- configuration options and their defaults

  -- `highlight` configures which highlight is used to display
  -- trailing whitespace
  highlight = "DiffDelete",

  -- `ignored_filetypes` configures which filetypes to ignore when
  -- displaying trailing whitespace
  ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "alpha", "toggleterm" },

  -- `ignore_terminal` configures whether to ignore terminal buffers
  ignore_terminal = true,
}

-- remove trailing whitespace with a keybinding
-- vim.keymap.set("n", "<Leader>t", require("whitespace-nvim").trim)
