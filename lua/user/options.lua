local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencodings = "utf-8,gb18030,gbk,gb2312,utf-16le,utf-16be", -- the encoding written to a file
  encoding = "utf-8", -- set encdoing
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  mousemoveevent = true, -- enable mouse move event
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by :qanother program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  cursorcolumn = true, -- highlight the current column
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  incsearch = true, -- enable incremental search
  laststatus = 2, -- always display statusline
  listchars = "tab:» ,nbsp:󰚌", -- show tabs with special icon
  background = "dark", -- dark background
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = true, -- display lines as one long line
  linebreak = true, -- companion to wrap, don't split words
  scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
  whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
  foldcolumn = "1", -- The width of a colum on the side of the window to indicate folds
  foldlevel = 99, -- The higher the more folder regions are open
  foldlevelstart = 99, -- Avoid auto fold
  foldenable = true, -- Default not fold any thing
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]], -- Set for foldcolumn
  sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions", -- Session save options
  textwidth = 512, -- Default text width
  spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add", -- Spell file
}

local old_isfname = vim.o.isfname

if require("util.os").is_windows() then
  -- NOTE: Make spellfile could contain ":"
  vim.o.isfname = vim.o.isfname .. ",:"
end

for k, v in pairs(options) do
  vim.opt[k] = v
end

if require("util.os").is_windows() then
  -- NOTE: Restore it
  -- vim.o.isfname = old_isfname
end

-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append "c" -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-" -- hyphenated words recognized by searches
vim.opt.formatoptions:remove { "c", "r", "o" } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove "/usr/share/vim/vimfiles" -- separate vim plugins from neovim in case vim still in use
vim.opt.sessionoptions = options.sessionoptions
vim.loader.enable() -- Enables the experimental Lua module loader

-- neovide related configure
if vim.g.neovide then
  vim.o.guifont = "DejaVuSansM Nerd Font:h8"
  vim.g.neovide_remember_window_size = true
end

-- other options
vim.g.rust_recommended_style = 0
