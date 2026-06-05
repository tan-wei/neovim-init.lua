local default_opts = { noremap = true, silent = true }
local yanky_plug_opts = { remap = true, silent = true }
local builtin = require "user.keymap.builtin"

---@type UserKeymapGroup[]
return {
  {
    plugin = "core",
    family = "plain",
    maps = {
      { mode = "n", lhs = "<C-Up>", rhs = ":resize -2<CR>", opts = default_opts },
      { mode = "n", lhs = "<C-Down>", rhs = ":resize +2<CR>", opts = default_opts },
      { mode = "n", lhs = "<C-Left>", rhs = ":vertical resize -2<CR>", opts = default_opts },
      { mode = "n", lhs = "<C-Right>", rhs = ":vertical resize +2<CR>", opts = default_opts },
      {
        mode = "n",
        lhs = "<S-l>",
        rhs = ":bnext<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "<S-l>") },
      },
      {
        mode = "n",
        lhs = "<S-h>",
        rhs = ":bprevious<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "<S-h>") },
      },
      { mode = "i", lhs = "jk", rhs = "<ESC>", opts = default_opts },
      { mode = "i", lhs = "kj", rhs = "<ESC>", opts = default_opts },
      { mode = "v", lhs = "<", rhs = "<gv^", opts = default_opts, conflict = { builtin = builtin.get("v", "<") } },
      { mode = "v", lhs = ">", rhs = ">gv^", opts = default_opts, conflict = { builtin = builtin.get("v", ">") } },
      { mode = "v", lhs = "p", rhs = '"_dP', opts = default_opts, conflict = { builtin = builtin.get("v", "p") } },
      {
        mode = "x",
        lhs = "J",
        rhs = ":m '>+1<CR>gv=gv",
        opts = default_opts,
        conflict = { builtin = builtin.get("x", "J") },
      },
      {
        mode = "x",
        lhs = "K",
        rhs = ":m '<-2<CR>gv=gv",
        opts = default_opts,
        conflict = { builtin = builtin.get("x", "K") },
      },
      { mode = "x", lhs = "<A-j>", rhs = ":m '>+1<CR>gv=gv", opts = default_opts },
      { mode = "x", lhs = "<A-k>", rhs = ":m '<-2<CR>gv=gv", opts = default_opts },
    },
  },
  {
    plugin = "cybu",
    family = "bracket",
    maps = {
      {
        mode = "n",
        lhs = "[b",
        rhs = "<Plug>(CybuPrev)",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "b",
          direction = "prev",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
      {
        mode = "n",
        lhs = "]b",
        rhs = "<Plug>(CybuNext)",
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "b",
          direction = "next",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
    },
  },
  {
    plugin = "nvim-scrollview",
    family = "bracket",
    maps = {
      {
        mode = "n",
        lhs = "[S",
        rhs = "<Plug>(ScrollViewPrev)",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "S",
          direction = "prev",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
      {
        mode = "n",
        lhs = "]S",
        rhs = "<Plug>(ScrollViewNext)",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "S",
          direction = "next",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
    },
  },
  {
    plugin = "gitsigns.nvim",
    family = "bracket",
    maps = {
      {
        mode = "n",
        lhs = "[g",
        rhs = "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "g",
          direction = "prev",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
      {
        mode = "n",
        lhs = "]g",
        rhs = "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "g",
          direction = "next",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
    },
  },
  {
    plugin = "refjump.nvim",
    family = "bracket",
    maps = {
      {
        mode = "n",
        lhs = "[r",
        rhs = function()
          require("refjump").reference_jump { forward = false }
        end,
        desc = "previous reference",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "r",
          direction = "prev",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
      {
        mode = "n",
        lhs = "]r",
        rhs = function()
          require("refjump").reference_jump { forward = true }
        end,
        desc = "next reference",
        opts = default_opts,
        symbol = {
          family = "bracket",
          role = "motion",
          namespace = "r",
          direction = "next",
          repeatable = true,
          repeat_engine = "demicolon",
        },
      },
    },
  },
  {
    plugin = "yanky.nvim",
    family = "plain",
    maps = {
      {
        mode = { "n", "x" },
        lhs = "y",
        rhs = "<Plug>(YankyYank)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "y") },
      },
      {
        mode = "n",
        lhs = "p",
        rhs = "<Plug>(YankyPutAfter)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "p") },
      },
      {
        mode = "n",
        lhs = "P",
        rhs = "<Plug>(YankyPutBefore)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "P") },
      },
      {
        mode = "n",
        lhs = "gp",
        rhs = "<Plug>(YankyGPutAfter)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "gp") },
      },
      {
        mode = "n",
        lhs = "<C-p>",
        rhs = "<Plug>(YankyPreviousEntry)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "<C-p>") },
      },
      {
        mode = "n",
        lhs = "<C-n>",
        rhs = "<Plug>(YankyNextEntry)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "<C-n>") },
      },
      {
        mode = "n",
        lhs = "]p",
        rhs = "<Plug>(YankyPutIndentAfterLinewise)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "]p") },
        symbol = { family = "bracket", role = "action", namespace = "p", direction = "next", repeatable = false },
      },
      {
        mode = "n",
        lhs = "[p",
        rhs = "<Plug>(YankyPutIndentBeforeLinewise)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "[p") },
        symbol = { family = "bracket", role = "action", namespace = "p", direction = "prev", repeatable = false },
      },
      {
        mode = "n",
        lhs = "]P",
        rhs = "<Plug>(YankyPutIndentAfterLinewise)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "]P") },
        symbol = { family = "bracket", role = "action", namespace = "P", direction = "next", repeatable = false },
      },
      {
        mode = "n",
        lhs = "[P",
        rhs = "<Plug>(YankyPutIndentBeforeLinewise)",
        opts = yanky_plug_opts,
        conflict = { builtin = builtin.get("n", "[P") },
        symbol = { family = "bracket", role = "action", namespace = "P", direction = "prev", repeatable = false },
      },
      {
        mode = "n",
        lhs = ">p",
        rhs = "<Plug>(YankyPutIndentAfterShiftRight)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "p", repeatable = false },
      },
      {
        mode = "n",
        lhs = "<p",
        rhs = "<Plug>(YankyPutIndentAfterShiftLeft)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "p", repeatable = false },
      },
      {
        mode = "n",
        lhs = ">P",
        rhs = "<Plug>(YankyPutIndentBeforeShiftRight)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "P", repeatable = false },
      },
      {
        mode = "n",
        lhs = "<P",
        rhs = "<Plug>(YankyPutIndentBeforeShiftLeft)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "P", repeatable = false },
      },
      {
        mode = "n",
        lhs = "=p",
        rhs = "<Plug>(YankyPutAfterFilter)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "p", repeatable = false },
      },
      {
        mode = "n",
        lhs = "=P",
        rhs = "<Plug>(YankyPutBeforeFilter)",
        opts = yanky_plug_opts,
        symbol = { family = "operator", role = "action", namespace = "P", repeatable = false },
      },
    },
  },
  {
    plugin = "high-str.nvim",
    family = "plain",
    maps = {
      { mode = "v", lhs = "<F3>", rhs = ":<c-u>HSHighlight 1<CR>", opts = default_opts },
      { mode = "v", lhs = "<F4>", rhs = ":<c-u>HSRmHighlight<CR>", opts = default_opts },
    },
  },
  {
    plugin = "overseer.nvim",
    family = "plain",
    maps = {
      {
        mode = "n",
        lhs = "<F5>",
        rhs = function()
          require("lazy").load { plugins = { "overseer.nvim" } }
          vim.cmd.OverseerRun()
        end,
        opts = default_opts,
      },
    },
  },
  {
    plugin = "colorscheme-randomizer",
    family = "plain",
    maps = {
      {
        mode = "",
        lhs = "<F8>",
        rhs = "<cmd>lua require('colorscheme-randomizer').randomize()<cr>",
        opts = default_opts,
      },
    },
  },
  {
    plugin = "treewalker.nvim",
    family = "plain",
    maps = {
      {
        mode = "n",
        lhs = "<C-j>",
        rhs = ":Treewalker Down<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "<C-j>") },
      },
      {
        mode = "n",
        lhs = "<C-k>",
        rhs = ":Treewalker Up<CR>",
        opts = default_opts,
        conflict = { note = "Reviewed normal-mode Ctrl-letter slot before reusing it for treewalker up" },
      },
      {
        mode = "n",
        lhs = "<C-h>",
        rhs = ":Treewalker Left<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "<C-h>") },
      },
      {
        mode = "n",
        lhs = "<C-l>",
        rhs = ":Treewalker Right<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "<C-l>") },
      },
    },
  },
  {
    plugin = "live-rename.nvim",
    family = "plain",
    maps = {
      {
        mode = "n",
        lhs = "<F2>",
        rhs = function()
          require("live-rename").rename { cursorpos = -1 }
          vim.schedule(function()
            vim.api.nvim_feedkeys("A", "n", false)
          end)
        end,
        opts = default_opts,
      },
    },
  },
  {
    plugin = "vim-easy-align",
    family = "g",
    maps = {
      {
        mode = "n",
        lhs = "ga",
        rhs = "<Plug>(EasyAlign)",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "ga") },
      },
      { mode = "x", lhs = "ga", rhs = "<Plug>(EasyAlign)", opts = default_opts },
    },
  },
  {
    plugin = "dial.nvim",
    family = "plain",
    maps = {
      {
        mode = "n",
        lhs = "<C-a>",
        rhs = function()
          require("dial.map").manipulate("increment", "normal")
        end,
        conflict = { builtin = builtin.get("n", "<C-a>") },
      },
      {
        mode = "n",
        lhs = "<C-x>",
        rhs = function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        conflict = { builtin = builtin.get("n", "<C-x>") },
      },
      {
        mode = "n",
        lhs = "g<C-a>",
        rhs = function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        conflict = { builtin = builtin.get("n", "g<C-a>") },
      },
      {
        mode = "n",
        lhs = "g<C-x>",
        rhs = function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        conflict = { builtin = builtin.get("n", "g<C-x>") },
      },
      {
        mode = "v",
        lhs = "<C-a>",
        rhs = function()
          require("dial.map").manipulate("increment", "visual")
        end,
        conflict = { builtin = builtin.get("v", "<C-a>") },
      },
      {
        mode = "v",
        lhs = "<C-x>",
        rhs = function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        conflict = { builtin = builtin.get("v", "<C-x>") },
      },
      {
        mode = "v",
        lhs = "g<C-a>",
        rhs = function()
          require("dial.map").manipulate("increment", "gvisual")
        end,
      },
      {
        mode = "v",
        lhs = "g<C-x>",
        rhs = function()
          require("dial.map").manipulate("decrement", "gvisual")
        end,
      },
    },
  },
  {
    plugin = "move.nvim",
    family = "plain",
    maps = {
      { mode = "n", lhs = "<A-j>", rhs = ":MoveLine(1)<CR>", opts = default_opts },
      { mode = "n", lhs = "<A-k>", rhs = ":MoveLine(-1)<CR>", opts = default_opts },
      { mode = "n", lhs = "<A-h>", rhs = ":MoveHChar(-1)<CR>", opts = default_opts },
      { mode = "n", lhs = "<A-l>", rhs = ":MoveHChar(1)<CR>", opts = default_opts },
      { mode = "n", lhs = "<leader>wf", rhs = ":MoveWord(1)<CR>", opts = default_opts },
      { mode = "n", lhs = "<leader>wb", rhs = ":MoveWord(-1)<CR>", opts = default_opts },
      { mode = "v", lhs = "<A-j>", rhs = ":MoveBlock(1)<CR>", opts = default_opts },
      { mode = "v", lhs = "<A-k>", rhs = ":MoveBlock(-1)<CR>", opts = default_opts },
      { mode = "v", lhs = "<A-h>", rhs = ":MoveHBlock(-1)<CR>", opts = default_opts },
      { mode = "v", lhs = "<A-l>", rhs = ":MoveHBlock(1)<CR>", opts = default_opts },
    },
  },
  {
    plugin = "oil.nvim",
    family = "plain",
    maps = {
      {
        mode = "n",
        lhs = "-",
        rhs = function()
          require("oil").toggle_float()
        end,
        conflict = { builtin = builtin.get("n", "-") },
      },
    },
  },
  {
    plugin = "fold-cycle.nvim",
    family = "z",
    maps = {
      {
        mode = "n",
        lhs = "<tab>",
        rhs = function()
          return require("fold-cycle").open()
        end,
        opts = { silent = true },
        desc = "Fold-cycle: open folds",
        conflict = { builtin = builtin.get("n", "<tab>") },
      },
      {
        mode = "n",
        lhs = "<s-tab>",
        rhs = function()
          return require("fold-cycle").close()
        end,
        opts = { silent = true },
        desc = "Fold-cycle: close folds",
      },
      {
        mode = "n",
        lhs = "zC",
        rhs = function()
          return require("fold-cycle").close_all()
        end,
        opts = { remap = true, silent = true },
        desc = "Fold-cycle: close all folds",
        conflict = { builtin = builtin.get("n", "zC") },
      },
    },
  },
  {
    plugin = "gx.nvim",
    family = "g",
    maps = {
      {
        mode = "n",
        lhs = "gx",
        rhs = "<cmd>Browse<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("n", "gx") },
      },
      {
        mode = "x",
        lhs = "gx",
        rhs = "<cmd>Browse<CR>",
        opts = default_opts,
        conflict = { builtin = builtin.get("x", "gx") },
      },
    },
  },
}
