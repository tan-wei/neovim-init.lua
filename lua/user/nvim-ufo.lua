local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
  return
end

local ftMap = {
  vim = "indent",
  python = { "indent" },
  git = "",
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
    -- if we prefer treesitter provider rather than lsp,
    -- return ftMap[filetype] or {'treesitter', 'indent'}
    return ftMap[filetype]
  end,
}

vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set("n", "K", function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    -- choose one of coc.nvim and nvim lsp
    vim.fn.CocActionAsync "definitionHover" -- coc.nvim
    vim.lsp.buf.hover()
  end
end)
