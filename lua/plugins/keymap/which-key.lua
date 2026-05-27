---@type LazyPluginSpec
local M = {
  "folke/which-key.nvim",
  lazy = false,
}

M.config = function()
  local wk = require "which-key"

  local function with_harpoon(callback)
    return function()
      local ok, harpoon = pcall(require, "harpoon")
      if not ok then
        return
      end

      callback(harpoon, harpoon:list())
    end
  end

  local function feed_normal(keys)
    return function()
      vim.api.nvim_feedkeys(vim.keycode(keys), "m", false)
    end
  end

  wk.setup {
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "<leader>", mode = { "n", "v" } },
      { "<localleader>", mode = { "n", "v" } },
    },
  }

  -- Shared retry budget for both the temporary bootstrap mapping below and
  -- the real trigger-priming pass further down.
  local startup_retry_delay = 50
  local startup_retry_attempts = 60

  -- Install a lightweight bootstrap trigger for leader/localleader while the
  -- real which-key triggers are still being primed. Keep it conservative:
  -- only show in the mode where the prefix was pressed, and never reopen when
  -- the popup is already visible.
  local seen_prefixes = {}
  for _, prefix in ipairs { vim.g.mapleader, vim.g.maplocalleader } do
    if prefix and prefix ~= "" and not seen_prefixes[prefix] then
      seen_prefixes[prefix] = true

      for _, mode in ipairs { "n", "x" } do
        vim.keymap.set(mode, prefix, function()
          local pressed_mode = vim.api.nvim_get_mode().mode

          local ok_view, wk_view = pcall(require, "which-key.view")
          if ok_view and wk_view.valid() then
            return
          end

          local function show_prefix(attempt)
            local ok_config, wk_config = pcall(require, "which-key.config")
            if not ok_config then
              return
            end

            if wk_config.loaded and wk_config.triggers and wk_config.triggers.modes then
              vim.schedule(function()
                if vim.api.nvim_get_mode().mode ~= pressed_mode then
                  return
                end

                local ok_current_view, current_view = pcall(require, "which-key.view")
                if ok_current_view and current_view.valid() then
                  return
                end

                require("which-key").show {
                  keys = prefix,
                  mode = pressed_mode,
                }
              end)
            elseif attempt < startup_retry_attempts then
              vim.defer_fn(function()
                show_prefix(attempt + 1)
              end, startup_retry_delay)
            end
          end

          show_prefix(0)
        end, {
          desc = "which-key-trigger bootstrap prefix",
          nowait = true,
        })
      end
    end
  end

  -- Prime the real which-key trigger state after startup and session restore.
  -- The bootstrap prefix mapping above keeps `<leader>` / `<localleader>` from
  -- going dead during the startup window; this pass is what lets the normal
  -- which-key-managed trigger mappings take over afterwards.
  --
  -- Why this exists:
  -- `lazy = false` only guarantees the plugin spec loads eagerly. which-key v3
  -- still finalizes parts of its trigger/buffer state around VimEnter and later
  -- event updates, so the first `<leader>` / `<localleader>` press can
  -- occasionally miss the popup until another interaction forces a rescan.
  --
  -- Related upstream discussion:
  -- https://github.com/folke/which-key.nvim/issues/787
  -- https://github.com/folke/which-key.nvim/issues/1029
  -- https://github.com/folke/which-key.nvim/issues/476
  -- https://github.com/folke/which-key.nvim/pull/942
  --
  -- This local workaround retries a small current-buffer refresh until
  -- which-key finishes its own deferred startup. A single `vim.schedule()` is
  -- not always enough here, because upstream also schedules its real config
  -- load on VimEnter; if we run first, internal fields such as
  -- `which-key.config.triggers.modes` may still be nil. We also rerun the same
  -- priming step after `SessionLoadPost`, since restoring a session can change
  -- the current buffer/window layout after the initial VimEnter pass.
  local function prime_current_buffer_triggers()
    local attempts = 0

    local function refresh_triggers()
      local ok_config, wk_config = pcall(require, "which-key.config")
      local ok_buf, wk_buf = pcall(require, "which-key.buf")
      local ok_triggers, wk_triggers = pcall(require, "which-key.triggers")
      if not (ok_config and ok_buf and ok_triggers) then
        return
      end

      if not (wk_config.loaded and wk_config.triggers and wk_config.triggers.modes) then
        attempts = attempts + 1
        if attempts < startup_retry_attempts then
          vim.defer_fn(refresh_triggers, startup_retry_delay)
        end
        return
      end

      for _, mode in ipairs { "n", "x" } do
        local ok_mode, wk_mode = pcall(wk_buf.get, { buf = 0, mode = mode })
        if ok_mode and wk_mode then
          pcall(wk_triggers.update, wk_mode)
        end
      end
    end

    vim.schedule(refresh_triggers)
  end

  vim.api.nvim_create_autocmd({ "VimEnter", "SessionLoadPost" }, {
    callback = function()
      prime_current_buffer_triggers()
    end,
  })

  wk.add {
    -- A --
    { "<leader>A", "<cmd>Alpha<cr>", desc = "Alpha", mode = "n" },

    -- a --
    { "<leader>a", "<cmd>NodeAction<cr>", desc = "node action", mode = "n" },

    -- B --

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
    { "<leader>bc", "<cmd>BdeleteOrClose<cr>", desc = "Close buffer", mode = "n" },
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
    {
      "<leader>bM",
      "<cmd>lua require('snipe').open_buffer_menu()<cr>",
      desc = "open buffer Menu",
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
    { "<leader>C", group = "cpp", mode = "n" },
    { "<leader>Cs", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source/header", mode = "n" },
    { "<leader>Ci", "<cmd>ClangdDisableInlayHints<cr>", desc = "disable Inlay hints", mode = "n" },
    { "<leader>CI", "<cmd>ClangdSetInlayHints<cr>", desc = "enable Inlay hints", mode = "n" },
    { "<leader>Ca", "<cmd>ClangdAST<cr>", desc = "view Abstract sytax tree", mode = "n" },
    { "<leader>CS", "<cmd>ClangdSymbolInfo<cr>", desc = "view Symbol information", mode = "n" },
    { "<leader>Ct", "<cmd>ClangdTypeHierarchy<cr>", desc = "view Type hierarchy information", mode = "n" },
    { "<leader>Cm", "<cmd>ClangdMemoryUsage<cr>", desc = "view Memory usage", mode = "n" },
    { "<leader>CD", "<cmd>DogeGenerate<cr>", desc = "Generate docblock", mode = "n" },
    { "<leader>Cf", "<cmd>TSCppDefineClassFunc<cr>", desc = "implement out of class member Functions", mode = "n" },
    {
      "<leader>Cc",
      "<cmd>TSCppMakeConcreteClass<cr>",
      desc = "implement a concrete class implementing all the pure virtual functions",
      mode = "n",
    },
    {
      "<leader>C3",
      "<cmd>TSCppRuleOf3<cr>",
      desc = "adds the missing function declarations to the class to boeth the rule of 3",
      mode = "n",
    },
    {
      "<leader>C5",
      "<cmd>TSCppRuleOf5<cr>",
      desc = "adds the missing function declarations to the class to boeth the rule of 5",
      mode = "n",
    },

    -- c --
    { "<leader>c", "<cmd>BdeleteOrClose<cr>", desc = "Close current buffer", mode = "n" },

    -- D --

    -- d --
    { "<leader>d", "<cmd>lua require('dropbar.api').pick()<cr>", desc = "Dropbar pick", mode = "n" },

    -- E --

    -- e --
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "toggle nvim-tree.lua Explorer", mode = "n" },

    -- F --
    {
      "<leader>F",
      "<cmd>Telescope live_grep_args live_grep_args theme=ivy<cr>",
      desc = "Find texts (rg args)",
      mode = "n",
    },

    -- f --
    {
      "<leader>f",
      "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      desc = "Find files",
      mode = "n",
    },

    -- O --
    {
      "<leader>o",
      "<cmd>Telescope smart_open<cr>",
      desc = "Smart open",
      mode = "n",
    },

    -- G --

    -- g --
    { "<leader>g", group = "git", mode = "n" },
    { "<leader>gB", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", mode = "n" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "checkout Branch", mode = "n" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "checkout Commit", mode = "n" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", mode = "n" },
    { "<leader>gl", "<cmd>LazyGit<cr>", desc = "Lazygit", mode = "n" },
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
    { "<leader>la", "<cmd>lua require('actions-preview').code_actions()<cr>", desc = "code Action", mode = "n" },
    { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics", mode = "n" },
    { "<leader>lD", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols", mode = "n" },
    { "<leader>lf", "<cmd>FormatEnable<cr>", desc = "enable Format", mode = "n" },
    { "<leader>lF", "<cmd>FormatDisable!<cr>", desc = "disable Format", mode = "n" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover({ border = 'rounded' })<cr>", desc = "Hover", mode = "n" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "LSP Information", mode = "n" },
    { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "LSP install Information", mode = "n" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "next diagostic", mode = "n" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "previous diagostic", mode = "n" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "codeLens action", mode = "n" },
    { "<leader>lo", "<cmd>SymbolsOutline<cr>", desc = "toggle symbols Outline", mode = "n" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix", mode = "n" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", mode = "n" },
    { "<leader>ls", "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", desc = "toggle Signature", mode = "n" },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "workspace Symbols", mode = "n" },

    -- M --
    { "<leader>M", group = "marks", mode = "n" },
    {
      "<leader>Mg",
      "<cmd>lua require('grapple').toggle()<cr>",
      desc = "toGgle grapple with annonymous tag",
      mode = "n",
    },
    {
      "<leader>Mj",
      "<cmd>lua require('grapple').select({key = '{name}'})<cr>",
      desc = "select grapple tag",
      mode = "n",
    },
    { "<leader>Ms", "<cmd>lua require('grapple').popup_scopes()<cr>", desc = "open the Scopes popup menu", mode = "n" },
    { "<leader>Mt", "<cmd>lua require('grapple').popup_tags()<cr>", desc = "open the Tags popup menu", mode = "n" },

    -- m --
    { "<leader>m", group = "harpoon", mode = "n" },
    {
      "<leader>ma",
      with_harpoon(function(_, list)
        local item = list.config.create_list_item(list.config)
        if item.value == nil or item.value == "" then
          return
        end

        local _, index = list:get_by_value(item.value)
        if index then
          list:remove_at(index)
          return
        end

        list:add(item)
      end),
      desc = "toggle current file",
      mode = "n",
    },
    {
      "<leader>mm",
      with_harpoon(function(harpoon, list)
        harpoon.ui:toggle_quick_menu(list)
      end),
      desc = "menu",
      mode = "n",
    },
    {
      "<leader>mn",
      with_harpoon(function(_, list)
        list:next { ui_nav_wrap = true }
      end),
      desc = "next file",
      mode = "n",
    },
    {
      "<leader>mp",
      with_harpoon(function(_, list)
        list:prev { ui_nav_wrap = true }
      end),
      desc = "previous file",
      mode = "n",
    },
    {
      "<leader>m1",
      with_harpoon(function(_, list)
        list:select(1)
      end),
      desc = "select file 1",
      mode = "n",
    },
    {
      "<leader>m2",
      with_harpoon(function(_, list)
        list:select(2)
      end),
      desc = "select file 2",
      mode = "n",
    },
    {
      "<leader>m3",
      with_harpoon(function(_, list)
        list:select(3)
      end),
      desc = "select file 3",
      mode = "n",
    },
    {
      "<leader>m4",
      with_harpoon(function(_, list)
        list:select(4)
      end),
      desc = "select file 4",
      mode = "n",
    },

    -- N --

    -- n --

    -- O --

    -- o --

    -- P --
    { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects", mode = "n" },

    -- p --
    { "<leader>p", group = "peek/popup", mode = "n" },
    {
      "<leader>pd",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Overlook: Peek definition",
      mode = "n",
    },
    {
      "<leader>pc",
      function()
        require("overlook.api").close_all()
      end,
      desc = "Overlook: Close all popups",
      mode = "n",
    },
    {
      "<leader>pu",
      function()
        require("overlook.api").restore_popup()
      end,
      desc = "Overlook: Restore popup",
      mode = "n",
    },
    {
      "<leader>pU",
      function()
        require("overlook.api").restore_all_popups()
      end,
      desc = "Overlook: Restore all popups",
      mode = "n",
    },
    {
      "<leader>pf",
      function()
        require("overlook.api").switch_focus()
      end,
      desc = "Overlook: Switch focus",
      mode = "n",
    },
    {
      "<leader>ps",
      function()
        require("overlook.api").open_in_split()
      end,
      desc = "Overlook: Open popup in split",
      mode = "n",
    },
    {
      "<leader>pv",
      function()
        require("overlook.api").open_in_vsplit()
      end,
      desc = "Overlook: Open popup in vsplit",
      mode = "n",
    },
    {
      "<leader>pt",
      function()
        require("overlook.api").open_in_tab()
      end,
      desc = "Overlook: Open popup in tab",
      mode = "n",
    },
    {
      "<leader>po",
      function()
        require("overlook.api").open_in_original_window()
      end,
      desc = "Overlook: Open popup in current window",
      mode = "n",
    },

    -- Q --

    -- q --
    { "<leader>q", group = "macro", mode = "n" },
    { "<leader>qq", feed_normal "q", desc = "Start/stop recording", mode = "n" },
    { "<leader>qp", feed_normal "Q", desc = "Play macro", mode = "n" },
    { "<leader>qs", feed_normal "<C-q>", desc = "Switch macro slot", mode = "n" },
    { "<leader>qe", feed_normal "cq", desc = "Edit macro", mode = "n" },
    { "<leader>qy", feed_normal "yq", desc = "Yank macro", mode = "n" },
    { "<leader>qd", feed_normal "dq", desc = "Delete all macros", mode = "n" },

    -- R --
    { "<leader>R", group = "repl", mode = "n" },
    { "<leader>Rr", "<cmd>IronRepl<cr>", desc = "Run repl", mode = "n" },
    { "<leader>Rs", "<cmd>IronRestart<cr>", desc = "reStart repl", mode = "n" },
    { "<leader>RS", "<cmd>SnipRun<cr>", desc = "Sniprun", mode = "n" },
    { "<leader>Rf", "<cmd>IronFocus<cr>", desc = "Focus repl", mode = "n" },
    { "<leader>Rh", "<cmd>IronHide<cr>", desc = "Hide repl", mode = "n" },
    {
      "<leader>Rc",
      function()
        require("iron.core").send_file()
      end,
      desc = "send Current file to repl",
      mode = "n",
    },
    {
      "<leader>Rl",
      function()
        require("iron.core").send_until_cursor()
      end,
      desc = "send the buffer from start Until the line to repl",
      mode = "n",
    },

    -- r --
    { "<leader>r", group = "run", mode = "n" },
    { "<leader>rc", "<cmd>RunCode<cr>", desc = "run Code based on file type with porject if supported", mode = "n" },
    { "<leader>rf", "<cmd>RunFile<cr>", desc = "run the current File", mode = "n" },
    { "<leader>rs", "<cmd>RunClose<cr>", desc = "Stop runner", mode = "n" },

    -- S --

    -- s --
    { "<leader>s", group = "search", mode = "n" },
    {
      "<leader>ss",
      function()
        require("flash").jump()
      end,
      desc = "Search",
      mode = "n",
    },
    {
      "<leader>sS",
      function()
        require("flash").treesitter()
      end,
      desc = "Search treesitter",
      mode = "n",
    },
    {
      "<leader>sy",
      function()
        require("telescope").extensions.yank_history.yank_history()
      end,
      desc = "Search yank history",
      mode = { "n", "x" },
    },
    {
      "<leader>sg",
      function()
        require("grug-far").open()
      end,
      desc = "Search replace",
      mode = "n",
    },
    {
      "<leader>sg",
      function()
        require("grug-far").with_visual_selection()
      end,
      desc = "Search replace selection",
      mode = "x",
    },
    {
      "<leader>sf",
      function()
        require("grug-far").open {
          prefills = {
            paths = vim.fn.expand "%",
          },
        }
      end,
      desc = "Search replace file",
      mode = "n",
    },
    {
      "<leader>sf",
      function()
        require("grug-far").with_visual_selection {
          prefills = {
            paths = vim.fn.expand "%",
          },
        }
      end,
      desc = "Search replace selection in file",
      mode = "x",
    },
    {
      "<leader>si",
      function()
        require("grug-far").open {
          visualSelectionUsage = "auto-detect",
        }
      end,
      desc = "Search within range",
      mode = "x",
    },
    { "<leader>sa", "<cmd>Telescope ast_grep<cr>", desc = "Search AST grep", mode = "n" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer", mode = "n" },
    { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Search colorschemes", mode = "n" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Search commands", mode = "n" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search help", mode = "n" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymaps", mode = "n" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Search man pages", mode = "n" },
    { "<leader>so", "<cmd>Telescope smart_open<cr>", desc = "Search smart open", mode = "n" },
    { "<leader>sp", "<cmd>Telescope builtin include_extensions=true<cr>", desc = "Search pickers", mode = "n" },
    { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Search recent files", mode = "n" },
    { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Search registers", mode = "n" },

    -- T --
    { "<leader>T", group = "terminal", mode = "n" },
    { "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", desc = "terminal Float", mode = "n" },
    { "<leader>Th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "terminal Horizontal", mode = "n" },
    { "<leader>Tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "terminal Vertical", mode = "n" },

    -- t --
    { "<leader>t", group = "table/toc/test", mode = "n" },
    { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "table Mode toggle", mode = "n" },
    { "<leader>tg", "<cmd>GenTocGFM<cr>", desc = "Generate toc", mode = "n" },
    { "<leader>tr", "<cmd>RemoveToc<cr>", desc = "Remove toc", mode = "n" },
    { "<leader>tu", "<cmd>UpdateToc<cr>", desc = "Update toc", mode = "n" },
    { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "run the Nearest test", mode = "n" },
    { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "re-run the Last", mode = "n" },
    {
      "<leader>tc",
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      desc = "run the Current file",
      mode = "n",
    },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "toggle test Summary", mode = "n" },
    {
      "<leader>to",
      "<cmd>lua require('neotest').output.open({ enter = false })<cr>",
      desc = "open the Output of a test result",
      mode = "n",
    },
    {
      "<leader>tp",
      "<cmd>lua require('neotest').output_panel.toggle()<cr>",
      desc = "toggle the out Panel",
      mode = "n",
    },
    {
      "<leader>tw",
      "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>",
      desc = "toggle Watching the current file",
      mode = "n",
    },
    {
      "<leader>tj",
      "<cmd>llua require('neotest').jump.next({ status = 'failed' })<cr>",
      desc = "jump to next failed test",
      mode = "n",
    },
    {
      "<leader>tk",
      "<cmd>llua require('neotest').jump.prev({ status = 'failed' })<cr>",
      desc = "jump to previous failed test",
      mode = "n",
    },

    -- U --

    -- u --

    -- V --

    -- v --

    -- W --

    -- w --
    { "<leader>w", group = "workspace", mode = "n" },
    { "<leader>wl", "<cmd>Telescope session-lens<cr>", desc = "session Lens", mode = "n" },
    { "<leader>ws", "<cmd>AutoSession save<cr>", desc = "session Save", mode = "n" },
    { "<leader>wd", "<cmd>AutoSession deletePicker<cr>", desc = "Delete a selected session", mode = "n" },
    { "<leader>wt", "<cmd>AutoSession toggle<cr>", desc = "session Toggle", mode = "n" },

    -- X --

    -- x --

    -- Y --

    -- y --
    { "<leader>y", group = "yazi", mode = "n" },
    { "<leader>yc", "<cmd>Yazi cwd<cr>", desc = "yazi with Cwd", mode = "n" },
    { "<leader>yy", "<cmd>Yazi<cr>", desc = "open Yazi at the current file", mode = "n" },
    { "<leader>yt", "<cmd>Yazi toggle<cr>", desc = "Toggle the last yazi session", mode = "n" },

    -- Z --

    -- z --

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
--       c = { "<cmd>lua require('treesitter-context').go_to_context()<cr>", "Jump to context" },
--       w = {
--         "<cmd>Telescope diagnostics<cr>",
--         "Workspace Diagnostics",
--       },
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
--     },
--     T = {
--       name = "Terminal",
--       n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
--       u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
--       t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
--       p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
--     },

return M
