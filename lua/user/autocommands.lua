local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local general_group = augroup "general"

vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  pattern = { "qf", "help", "man", "lspinfo" },
  desc = "Close auxiliary windows with q",
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = args.buf,
      silent = true,
    })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_group,
  desc = "Avoid continuing comments on new lines",
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  pattern = "qf",
  desc = "Keep quickfix windows out of buffer lists",
  callback = function(args)
    vim.bo[args.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup "auto_resize",
  desc = "Equalize split sizes after resizing Neovim",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = augroup "alpha",
  pattern = "AlphaReady",
  desc = "Hide the tabline while Alpha is visible",
  callback = function(args)
    local buffer = args.buf ~= 0 and args.buf or vim.api.nvim_get_current_buf()
    local previous_showtabline = vim.o.showtabline

    vim.o.showtabline = 0

    vim.api.nvim_create_autocmd("BufUnload", {
      group = augroup "alpha_restore",
      buffer = buffer,
      once = true,
      desc = "Restore the tabline after Alpha closes",
      callback = function()
        vim.o.showtabline = previous_showtabline
      end,
    })
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
  group = augroup "sample_filetype",
  pattern = "*.sample",
  desc = "Detect filetype from sample file basename",
  callback = function(args)
    local fname = vim.fn.fnamemodify(args.match, ":t")
    local real_name = fname:gsub("%.sample$", "")
    if real_name == "" then
      return
    end
    local ft = vim.filetype.match { filename = real_name }
    if ft then
      vim.bo[args.buf].filetype = ft
    end
  end,
})
