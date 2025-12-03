vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end
]]

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- TODO: Do something related to colorscheme changed
  end,
})

-- Make them winfixbuf, alternative to stickybuf.nvim
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     if vim.list_contains({ "NvimTree", "OverseerList", "aerial", "toggleterm", "dbui", "dbout" }, vim.bo.filetype) then
--       vim.wo.winfixbuf = true
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.sample",
  callback = function(args)
    local fname = vim.fn.expand "%:t"
    local real_name = fname:gsub("%.sample$", "")
    if real_name == "" then
      return
    end
    local ft = vim.filetype.match { filename = real_name }
    if ft then
      vim.bo.filetype = ft
    end
  end,
})
