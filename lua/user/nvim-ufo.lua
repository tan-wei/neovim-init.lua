local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
  return
end

local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
  lua = { "lsp", "treesitter" },
  rust = { "lsp", "treesitter" },
  c = { "lsp", "treesitter" },
  cpp = { "lsp", "treesitter" },
}

ufo.setup {
  open_fold_hl_timeout = 150,
  close_fold_kinds = { "imports", "comment" },
  preview = {
    win_config = {
      border = { "", "─", "", "", "", "─", "", "" },
      winhighlight = "Normal:Folded",
      winblend = 0,
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
      jumpTop = "[",
      jumpBot = "]",
    },
  },
  provider_selector = function(bufnr, filetype, buftype)
    if vim.bo[bufnr].buftype == "nofile" then
      return ""
    end
    return ftMap[filetype] or { "treesitter", "indent" }
  end,
}

vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
vim.keymap.set("n", "zm", ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "K", function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

local status_ok, statuscol = pcall(require, "statuscol")
if not status_ok then
  return
end

local builtin = require "statuscol.builtin"
statuscol.setup {
  relculright = true,
  segments = {
    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
    { text = { "%s" }, click = "v:lua.ScSa" },
    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
  },
}
