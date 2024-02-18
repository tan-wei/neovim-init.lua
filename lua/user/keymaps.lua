local M = {}

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

M.setup = function()
  --Remap space as leader key
  -- keymap("", "<Space>", "<Nop>", opts)
  -- vim.g.mapleader = "\\"
  -- vim.g.maplocalleader = "\\"

  -- Modes
  --   normal_mode = "n",
  --   insert_mode = "i",
  --   visual_mode = "v",
  --   visual_block_mode = "x",
  --   term_mode = "t",
  --   command_mode = "c",

  -- Normal --
  -- Better window navigation
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
  keymap("n", "<C-l>", "<C-w>l", opts)

  -- Resize with arrows
  keymap("n", "<C-Up>", ":resize -2<CR>", opts)
  keymap("n", "<C-Down>", ":resize +2<CR>", opts)
  keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
  keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

  -- Navigate buffers
  keymap("n", "<S-l>", ":bnext<CR>", opts)
  keymap("n", "<S-h>", ":bprevious<CR>", opts)

  -- Move text up and down
  keymap("n", "<A-j>", ":m .+1<CR>==", opts)
  keymap("n", "<A-k>", ":m .-2<CR>==", opts)

  -- Insert --
  -- Press jk fast to exit insert mode
  keymap("i", "jk", "<ESC>", opts)
  keymap("i", "kj", "<ESC>", opts)

  -- Visual --
  -- Stay in indent mode
  keymap("v", "<", "<gv^", opts)
  keymap("v", ">", ">gv^", opts)

  -- Move text up and down
  keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
  keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
  keymap("v", "p", '"_dP', opts)

  -- Visual Block --
  -- Move text up and down
  keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
  keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
  keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
  keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

  -- Terminal --
  -- Better terminal navigation
  -- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
  -- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
  -- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
  -- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

  -- clever-f --
  -- Keeping the functionality of ; and , via mappings
  keymap("", ";", "<Plug>(clever-f-repeat-forward)", opts)
  keymap("", ",", "<Plug>(clever-f-repeat-back)", opts)

  -- high-str --
  keymap("v", "<F3>", ":<c-u>HSHighlight 1<CR>", opts)

  keymap("v", "<F4>", ":<c-u>HSRmHighlight<CR>", opts)

  -- bufferline.nvim --
  keymap("", "<Leader>1", ":BufferLineGoToBuffer 1<CR>", opts)
  keymap("", "<Leader>2", ":BufferLineGoToBuffer 2<CR>", opts)
  keymap("", "<Leader>3", ":BufferLineGoToBuffer 3<CR>", opts)
  keymap("", "<Leader>4", ":BufferLineGoToBuffer 4<CR>", opts)
  keymap("", "<Leader>5", ":BufferLineGoToBuffer 5<CR>", opts)
  keymap("", "<Leader>6", ":BufferLineGoToBuffer 6<CR>", opts)
  keymap("", "<Leader>7", ":BufferLineGoToBuffer 7<CR>", opts)
  keymap("", "<Leader>8", ":BufferLineGoToBuffer 8<CR>", opts)
  keymap("", "<Leader>9", ":BufferLineGoToBuffer 9<CR>", opts)
  keymap("", "<Leader>$", ":BufferLineGoToBuffer -1<CR>", opts)

  keymap("", "<F8>", "<cmd>lua require('colorscheme-randomizer').randomize()<cr>", opts)
end

M.which_key_mapping = {
  A = { "<cmd>Alpha<cr>", "Alpha" },
  a = {},
  B = {},
  b = {
    name = "Buffers",
    i = { "<cmd>lua require 'ibl'.setup_buffer(0, { enabled = false })<cr>", "Disable indent-blankline" },
    I = { "<cmd>lua require 'ibl'.setup_buffer(0, { enabled = true })<cr>", "Enable indent-blankline" },
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
    b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
    n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
    W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
    -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
    e = {
      "<cmd>BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
    t = {
      "<cmd>lua require('buffer_manager.ui').toggle_quick_menu()<cr>",
      "Toggle quick menu",
    },
  },
  C = {},
  c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  D = {},
  d = { "<cmd>lua require('dropbar.api').pick()<cr>", "Dropbar pick" },
  E = {},
  e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  f = {
    "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    "Find files",
  },
  G = {},
  g = {
    name = "Git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Diff",
    },
  },
  H = {},
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  I = {},
  i = {},
  J = {},
  j = {},
  K = {},
  k = {},
  L = {},
  l = {
    name = "LSP",
    a = { "<cmd>lua require('actions-preview').code_actions()<cr>", "Code Action" },
    c = { "<cmd>lua require('treesitter-context').go_to_context()<cr>", "Jump to context" },
    d = {
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      "Document Diagnostics",
    },
    D = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    w = {
      "<cmd>Telescope diagnostics<cr>",
      "Workspace Diagnostics",
    },
    f = { "<cmd>FormatEnable<cr>", "Enable Format" },
    F = { "<cmd>FormatDisable!<cr>", "Disable Format" },
    h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline " },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", "Toggle Signature" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
  },
  M = {
    name = "Marks",
    g = { "<cmd>lua require('grapple').toggle()<cr>", "Toggle grapple with annoymous tag" },
    j = { "<cmd>lua require('grapple').select({key = '{name}'})<cr>", "Select grapple tag" },
    s = { "<cmd>lua require('grapple').popup_scopes()<cr>", "Open the scopes popup menu" },
    t = { "<cmd>lua require('grapple').popup_tags()<cr>", "Open the tags popup menu" },
  },
  m = {},
  N = {},
  n = {},
  O = {},
  o = {},
  P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
  p = {
    name = "Plugins",
    i = { "<cmd>Lazy install<cr>", "Install" },
    s = { "<cmd>Lazy sync<cr>", "Sync" },
    S = { "<cmd>Lazy clear<cr>", "Status" },
    c = { "<cmd>Lazy clean<cr>", "Clean" },
    u = { "<cmd>Lazy update<cr>", "Update" },
    p = { "<cmd>Lazy profile<cr>", "Profile" },
    l = { "<cmd>Lazy log<cr>", "Log" },
    d = { "<cmd>Lazy debug<cr>", "Debug" },
  },
  Q = {},
  q = {},
  R = {
    name = "REPL",
    r = { "<cmd>IronRepl<cr>", "Run Repl" },
    s = { "<cmd>IronRestart<cr>", "reStart Repl" },
    f = { "<cmd>IronFocus<cr>", "Focus REPL" },
    h = { "<cmd>IronHide<cr>", "Hide REPL" },
    c = {
      function()
        require("iron.core").send_file()
      end,
      "send Current file to Repl",
    },
    l = {
      function()
        require("iron.core").send_line()
      end,
      "send the Line to Repl",
    },
    u = {
      function()
        require("iron.core").send_until_cursor()
      end,
      "send the buffer from start Until the line to Repl",
    },
  },
  r = {
    name = "Run",
    c = { "<cmd>RunFile<cr>", "Run Code based on file type with porject if supported" },
    f = { "<cmd>RunFile<cr>", "Run the current File" },
    s = { "<cmd>RunClose<cr>", "Stop Runner" },
  },
  S = {},
  s = {
    name = "Search",
    -- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    -- c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    -- h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    -- M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    -- R = { "<cmd>Telescope registers<cr>", "Registers" },
    -- k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    -- C = { "<cmd>Telescope commands<cr>", "Commands" },
    s = {
      function()
        require("flash").jump()
      end,
      "Flash",
    },
    S = {
      function()
        require("flash").treesitter()
      end,
      "Flash Treesitter",
    },
    r = { "<cmd>lua require('spectre').toggle()<cr>", "Toggle Spectre" },
  },
  T = {
    name = "Terminal",
    n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },
  t = {
    name = "Table/TOC/Test",
    m = { "<cmd>TableModeToggle<cr>", "Table Mode Toggle" },
    g = { "<cmd>GenTocGFM<cr>", "Generate TOC" },
    r = { "<cmd>RemoveToc<cr>", "Remove TOC" },
    u = { "<cmd>UpdateToc<cr>", "Update TOC" },
    n = { "<cmd>lua require('neotest').run.run()<cr>", "Run the Nearest test" },
    l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Re-run the Last position test that was run" },
    c = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run the Current file" },
    s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Toggle test Summary" },
    o = { "<cmd>lua require('neotest').output.open({ enter = false })<cr>", "Open the Output of a test result" },
    p = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Toggle the output Panel" },
    w = { "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", "Toggle Watching the current file" },
    j = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Jump to next falied test" },
    k = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Jump to previous falied test" },
  },
  U = {},
  u = {},
  V = {},
  v = {},
  W = {},
  w = {
    name = "Workspace",
    l = { "<cmd>Telescope session-lens<cr>", "Session Lens" },
    s = { "<cmd>SessionSave<cr>", "Save Session" },
    d = { "<cmd>Autosession delete<cr>", "Delete a selected Session" },
  },
  X = {},
  x = {},
  Y = {},
  y = {},
  Z = {},
  z = {},
}

return M
