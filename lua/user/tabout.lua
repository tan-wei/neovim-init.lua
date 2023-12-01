local status_ok, tabout = pcall(require, "tabout")
if not status_ok then
  return
end

tabout.setup {
  tabkey = "<Tab>",
  backwards_tabkey = "<S-Tab>",
  act_as_tab = true,
  act_as_shift_tab = false,
  default_tab = "<C-t>",
  default_shift_tab = "<C-d>",
  enable_backwards = true,
  completion = true,
  tabouts = {
    { open = "'", close = "'" },
    { open = '"', close = '"' },
    { open = "`", close = "`" },
    { open = "(", close = ")" },
    { open = "[", close = "]" },
    { open = "{", close = "}" },
  },
  ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
  exclude = {}, -- tabout will ignore these filetypes
}
