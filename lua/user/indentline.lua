local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
  return
end

-- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = "99999"

-- Workaound, auto highlight when refresh colorscheme
-- see here: https://github.com/lukas-reineke/indent-blankline.nvim/issues/553
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   desc = "Refresh indent colors",
--   callback = function()
--     vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
--     vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
--     vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
--     vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
--     vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
--     vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
--   end,
-- })

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "space:"
vim.opt.listchars:append "eol:↴"

indent_blankline.setup {
  show_end_of_line = true,
  show_trailing_blankline_indent = true,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  char_list = { "|", "¦", "┆", "┊" },
  context_char_list = { "┃", "║", "╬", "█" },
  indent_level = 20,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
  },
  -- char_highlight_list = {
  --   "IndentBlanklineIndent1",
  --   "IndentBlanklineIndent2",
  --   "IndentBlanklineIndent3",
  --   "IndentBlanklineIndent4",
  --   "IndentBlanklineIndent5",
  --   "IndentBlanklineIndent6",
  -- },
}
