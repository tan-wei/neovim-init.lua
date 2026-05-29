---@param name string
---@return integer
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local general_group = augroup "general"

local auxiliary_close_filetypes = {
  help = true,
  lspinfo = true,
  man = true,
  qf = true,
}

---@param buf integer
---@param rhs string|function
---@param desc string
local function map_close_with_q(buf, rhs, desc)
  vim.keymap.set("n", "q", rhs, {
    buffer = buf,
    silent = true,
    nowait = true,
    desc = desc,
  })
end

local function close_current_health_view()
  if vim.fn.tabpagenr "$" > 1 then
    vim.cmd "tabclose"
    return
  end

  vim.cmd "close"
end

local spell_comment_filetypes = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "go",
  "javascript",
  "javascriptreact",
  "lua",
  "python",
  "rust",
  "sh",
  "toml",
  "typescript",
  "typescriptreact",
  "vim",
  "yaml",
  "zsh",
}

vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  pattern = { "qf", "help", "man", "lspinfo", "checkhealth" },
  desc = "Close auxiliary views with q",
  callback = function(args)
    if vim.bo[args.buf].filetype == "checkhealth" then
      map_close_with_q(args.buf, close_current_health_view, "Close health tab")
      return
    end

    map_close_with_q(args.buf, "<cmd>close<cr>", "Close auxiliary window")
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_group,
  desc = "Close transient floating scratch windows with q",
  callback = function(args)
    local buf = args.buf
    if auxiliary_close_filetypes[vim.bo[buf].filetype] or vim.bo[buf].filetype == "checkhealth" then
      return
    end

    local win_config = vim.api.nvim_win_get_config(0)
    local is_transient_float = win_config.relative ~= ""
      and vim.bo[buf].buftype == "nofile"
      and not vim.bo[buf].modifiable

    if is_transient_float then
      map_close_with_q(buf, "<cmd>close<cr>", "Close transient window")
    end
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
  pattern = spell_comment_filetypes,
  desc = "Enable spell checking for comment spell regions in common code files",
  callback = function()
    vim.opt_local.spell = true
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
