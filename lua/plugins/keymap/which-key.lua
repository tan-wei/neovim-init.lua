local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

M.config = function()
  local wk = require "which-key"
  wk.setup()

  wk.add {
    -- A --
    { "<leader>A", "<cmd>Alpha<cr>", desc = "Alpha", mode = "n" },

    -- a --
    { "<leader>a", group = "add" },
    {
      "<leader>an",
      "<cmd>lua require('attempt').new_select()<cr>",
      desc = "New with selecting extension",
      mode = "n",
    },
    {
      "<leader>ai",
      "<cmd>lua require('attempt').new_input_ext()<cr>",
      desc = "new with Inputing extension",
      mode = "n",
    },
    { "<leader>ar", "<cmd>lua require('attempt').run()<cr>", desc = "Run temporary buffer", mode = "n" },
    { "<leader>ad", "<cmd>lua require('attempt').delete_buf()<cr>", desc = "Delete temporary buffer", mode = "n" },
    { "<leader>ae", "<cmd>lua require('attempt').rename_buf()<cr>", desc = "rEname temporary buffer", mode = "n" },

    -- B --
    {
      "<leader>B",
      group = "Buffers",
      expand = function()
        return require("which-key.extras").expand.buf()
      end,
    },

    -- b --
    { "<leader>b", group = "buffer", mode = "n" },
    { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "previous buffer", mode = "n" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer", mode = "n" },
    {
      "<leader>bi",
      "<cmd>lua require 'ibl'.setup_buffer(0, { enabled = false })<cr>",
      desc = "disable Indent-blankline",
      mode = "n",
    },
    { "<leader>bc", "<cmd>Bdelete!<cr>", desc = "Close buffer", mode = "n" },
    {
      "<leader>bI",
      "<cmd>lua require 'ibl'.setup_buffer(0, { enabled = true })<cr>",
      desc = "enable Indent-blankline",
      mode = "n",
    },
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer", mode = "n" },
    { "<leader>bP", "<cmd>BufferLinePickClose<cr>", desc = "close Pick buffer", mode = "n" },
    { "<leader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find buffer", mode = "n" },
    { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "close all to the left", mode = "n" },
    { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "close all to the right", mode = "n" },
    {
      "<leader>bm",
      "<cmd>lua require('buffer_manager.ui').toggle_quick_menu()<cr>",
      desc = "toggle quick Menu",
      mode = "n",
    },
    { "<leader>bsd", "<cmd>BufferLineSortByDirectory<cr>", desc = "buffer Sort by Directory", mode = "n" },
    { "<leader>bsl", "<cmd>BufferLineSortByExtension<cr>", desc = "buffer Sort by Language", mode = "n" },
    { "<leader>bst", "<cmd>BufferLineSortByTabs<cr>", desc = "buffer Sort by Tabs", mode = "n" },
    {
      "<leader>bsr",
      "<cmd>BufferLineSortByRelativeDirectory<cr>",
      desc = "buffer Sort by Relative directory",
      mode = "n",
    },
    -- C --

    -- c --

    -- D --

    -- d --
    { "<leader>d", "<cmd>lua require('dropbar.api').pick()<cr>", desc = "Dropbar pick", mode = "n" },

    -- E --

    -- e --
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "toggle nvim-tree.lua Explorer", mode = "n" },

    -- F --
    { "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find texts", mode = "n" },

    -- f --
    {
      "<leader>f",
      "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      desc = "Find files",
      mode = "n",
    },

    -- G --

    -- g --
    { "<leader>g", group = "git", mode = "n" },
    { "<leader>gB", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", mode = "n" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "checkout Branch", mode = "n" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "checkout Commit", mode = "n" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", mode = "n" },
    { "<leader>gl", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Lazygit", mode = "n" },
    { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "next hunk", mode = "n" },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "previous hunk", mode = "n" },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview hunk", mode = "n" },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset hunk", mode = "n" },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset buffer", mode = "n" },
    { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage hunk", mode = "n" },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo stage hunk", mode = "n" },
    { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file", mode = "n" },

    -- H --

    -- h --
    { "<leader>h", "<cmd>nohlsearch<cr>", desc = "no Highlight search", mode = "n" },

    -- I --

    -- i --

    -- J --

    -- j --
    { "<leader>j", group = "jump", mode = "n" },
    { "<leader>jj", "<cmd>Portal jumplist forward<cr>", desc = "jump forward", mode = "n" },
    { "<leader>jk", "<cmd>Portal jumplist backward<cr>", desc = "jump backward", mode = "n" },
    { "<leader>jcj", "<cmd>Portal changelist forward<cr>", desc = "jump Changelist forward", mode = "n" },
    { "<leader>jck", "<cmd>Portal changelist backward<cr>", desc = "jump Changelist backward", mode = "n" },
    { "<leader>jgj", "<cmd>Portal grapple forward<cr>", desc = "jump Grapple forward", mode = "n" },
    { "<leader>jgk", "<cmd>Portal grapple backward<cr>", desc = "jump Grapple backward", mode = "n" },
    { "<leader>jhj", "<cmd>Portal harpoon forward<cr>", desc = "jump Harpoon forward", mode = "n" },
    { "<leader>jhk", "<cmd>Portal harpoon backward<cr>", desc = "jump Harpoon backward", mode = "n" },
    { "<leader>jqj", "<cmd>Portal quickfix forward<cr>", desc = "jump Quickfix forward", mode = "n" },
    { "<leader>jqk", "<cmd>Portal quickfix backward<cr>", desc = "jump Quickfix backward", mode = "n" },

    -- K --

    -- k --

    -- L --
    { "<leader>L", group = "line", mode = "n" },
    { "<leader>Ld", "<cmd>Linediff<cr>", desc = "line Different selection", mode = "n" },
    { "<leader>Lr", "<cmd>LinediffReset<cr>", desc = "line different Reset", mode = "n" },

    -- l --
    { "<leader>l", group = "lsp", mode = "n" },

    -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
    -- {
    --   "<leader>fb",
    --   function()
    --     print "hello"
    --   end,
    --   desc = "Foobar",
    -- },
    -- { "<leader>fn", desc = "New File" },
    -- { "<leader>f1", hidden = true }, -- hide this keymap
    -- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
    -- {
    --   "<leader>b",
    --   group = "buffers",
    --   expand = function()
    --     return require("which-key.extras").expand.buf()
    --   end,
    -- },
    -- {
    --   -- Nested mappings are allowed and can be added in any order
    --   -- Most attributes can be inherited or overridden on any level
    --   -- There's no limit to the depth of nesting
    --   mode = { "n", "v" }, -- NORMAL and VISUAL mode
    --   { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    --   { "<leader>w", "<cmd>w<cr>", desc = "Write" },
    -- },
  }
end

-- M.config = function()
--   local which_key = require "which-key"

--   which_key.register({
--     b = {
--       name = "Buffers",
--       W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
--       -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
--     },
--     C = {
--       name = "Commet Box",
--       -- TODO
--     },

--     l = {
--       name = "LSP",
--       a = { "<cmd>lua require('actions-preview').code_actions()<cr>", "Code Action" },
--       c = { "<cmd>lua require('treesitter-context').go_to_context()<cr>", "Jump to context" },
--       d = {
--         "<cmd>Telescope diagnostics bufnr=0<cr>",
--         "Document Diagnostics",
--       },
--       D = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
--       w = {
--         "<cmd>Telescope diagnostics<cr>",
--         "Workspace Diagnostics",
--       },
--       f = { "<cmd>FormatEnable<cr>", "Enable Format" },
--       F = { "<cmd>FormatDisable!<cr>", "Disable Format" },
--       h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
--       i = { "<cmd>LspInfo<cr>", "Info" },
--       I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
--       j = {
--         "<cmd>lua vim.diagnostic.goto_next()<CR>",
--         "Next Diagnostic",
--       },
--       k = {
--         "<cmd>lua vim.diagnostic.goto_prev()<cr>",
--         "Prev Diagnostic",
--       },
--       l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
--       o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline " },
--       q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
--       r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
--       s = { "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", "Toggle Signature" },
--       S = {
--         "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--         "Workspace Symbols",
--       },
--     },
--     M = {
--       name = "Marks",
--       g = { "<cmd>lua require('grapple').toggle()<cr>", "Toggle grapple with annoymous tag" },
--       j = { "<cmd>lua require('grapple').select({key = '{name}'})<cr>", "Select grapple tag" },
--       s = { "<cmd>lua require('grapple').popup_scopes()<cr>", "Open the scopes popup menu" },
--       t = { "<cmd>lua require('grapple').popup_tags()<cr>", "Open the tags popup menu" },
--     },
--     m = {},
--     N = {},
--     n = {},
--     O = {},
--     o = {},
--     P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
--     p = {
--       name = "Plugins",
--       i = { "<cmd>Lazy install<cr>", "Install" },
--       s = { "<cmd>Lazy sync<cr>", "Sync" },
--       S = { "<cmd>Lazy clear<cr>", "Status" },
--       c = { "<cmd>Lazy clean<cr>", "Clean" },
--       u = { "<cmd>Lazy update<cr>", "Update" },
--       p = { "<cmd>Lazy profile<cr>", "Profile" },
--       l = { "<cmd>Lazy log<cr>", "Log" },
--       d = { "<cmd>Lazy debug<cr>", "Debug" },
--     },
--     Q = {},
--     q = {},
--     R = {
--       name = "REPL",
--       r = { "<cmd>IronRepl<cr>", "Run Repl" },
--       s = { "<cmd>IronRestart<cr>", "reStart Repl" },
--       S = { "<cmd>SnipRun<cr>", "Run Sniprun" },
--       f = { "<cmd>IronFocus<cr>", "Focus REPL" },
--       h = { "<cmd>IronHide<cr>", "Hide REPL" },
--       c = {
--         function()
--           require("iron.core").send_file()
--         end,
--         "send Current file to Repl",
--       },
--       l = {
--         function()
--           require("iron.core").send_line()
--         end,
--         "send the Line to Repl",
--       },
--       u = {
--         function()
--           require("iron.core").send_until_cursor()
--         end,
--         "send the buffer from start Until the line to Repl",
--       },
--     },
--     r = {
--       name = "Run",
--       c = { "<cmd>RunFile<cr>", "Run Code based on file type with porject if supported" },
--       f = { "<cmd>RunFile<cr>", "Run the current File" },
--       s = { "<cmd>RunClose<cr>", "Stop Runner" },
--     },
--     S = {},
--     s = {
--       name = "Search",
--       -- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--       -- c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
--       -- h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
--       -- M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--       -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--       -- R = { "<cmd>Telescope registers<cr>", "Registers" },
--       -- k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--       -- C = { "<cmd>Telescope commands<cr>", "Commands" },
--       s = {
--         function()
--           require("flash").jump()
--         end,
--         "Flash",
--       },
--       S = {
--         function()
--           require("flash").treesitter()
--         end,
--         "Flash Treesitter",
--       },
--       r = { "<cmd>lua require('spectre').toggle()<cr>", "Toggle Spectre" },
--     },
--     T = {
--       name = "Terminal",
--       n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
--       u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
--       t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
--       p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
--       f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
--       h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
--       v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
--     },
--     t = {
--       name = "Table/TOC/Test",
--       m = { "<cmd>TableModeToggle<cr>", "Table Mode Toggle" },
--       g = { "<cmd>GenTocGFM<cr>", "Generate TOC" },
--       r = { "<cmd>RemoveToc<cr>", "Remove TOC" },
--       u = { "<cmd>UpdateToc<cr>", "Update TOC" },
--       n = { "<cmd>lua require('neotest').run.run()<cr>", "Run the Nearest test" },
--       l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Re-run the Last position test that was run" },
--       c = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run the Current file" },
--       s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Toggle test Summary" },
--       o = { "<cmd>lua require('neotest').output.open({ enter = false })<cr>", "Open the Output of a test result" },
--       p = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Toggle the output Panel" },
--       w = { "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", "Toggle Watching the current file" },
--       j = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Jump to next falied test" },
--       k = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Jump to previous falied test" },
--     },
--     U = {},
--     u = {},
--     V = {},
--     v = {},
--     W = {},
--     w = {
--       name = "Workspace",
--       l = { "<cmd>Telescope session-lens<cr>", "Session Lens" },
--       s = { "<cmd>SessionSave<cr>", "Save Session" },
--       d = { "<cmd>Autosession delete<cr>", "Delete a selected Session" },
--     },
--     X = {},
--     x = {},
--     Y = {},
--     y = {},
--     Z = {},
--     z = {},
--   }, {
--     mode = "n", -- NORMAL mode
--     prefix = "<leader>",
--     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--     silent = true, -- use `silent` when creating keymaps
--     noremap = true, -- use `noremap` when creating keymaps
--     nowait = true, -- use `nowait` when creating keymaps
--   })

--   which_key.register({}, {
--     mode = "n", -- NORMAL mode
--     prefix = "<space>",
--     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--     silent = true, -- use `silent` when creating keymaps
--     noremap = true, -- use `noremap` when creating keymaps
--     nowait = true, -- use `nowait` when creating keymaps
--   })
-- end

return M
