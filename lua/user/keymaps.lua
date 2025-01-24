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

  -- Buffer related
  keymap("n", "[b", "<Plug>(CybuPrev)", opts)
  keymap("n", "]b", "<Plug>(CybuNext)")
  -- keymap("n", "<S-Tab>", "<plug>(CybuLastusedPrev)", opts)
  -- keymap("n", "<Tab>", "<plug>(CybuLastusedNext)", opts)

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

  -- high-str --
  keymap("v", "<F3>", ":<c-u>HSHighlight 1<CR>", opts)

  keymap("v", "<F4>", ":<c-u>HSRmHighlight<CR>", opts)

  -- bufferline.nvim --
  -- keymap("", "<Leader>1", ":BufferLineGoToBuffer 1<CR>", opts)
  -- keymap("", "<Leader>2", ":BufferLineGoToBuffer 2<CR>", opts)
  -- keymap("", "<Leader>3", ":BufferLineGoToBuffer 3<CR>", opts)
  -- keymap("", "<Leader>4", ":BufferLineGoToBuffer 4<CR>", opts)
  -- keymap("", "<Leader>5", ":BufferLineGoToBuffer 5<CR>", opts)
  -- keymap("", "<Leader>6", ":BufferLineGoToBuffer 6<CR>", opts)
  -- keymap("", "<Leader>7", ":BufferLineGoToBuffer 7<CR>", opts)
  -- keymap("", "<Leader>8", ":BufferLineGoToBuffer 8<CR>", opts)
  -- keymap("", "<Leader>9", ":BufferLineGoToBuffer 9<CR>", opts)
  -- keymap("", "<Leader>$", ":BufferLineGoToBuffer -1<CR>", opts)

  keymap("", "<F8>", "<cmd>lua require('colorscheme-randomizer').randomize()<cr>", opts)

  -- Treewalker.nvim
  keymap("n", "<C-j>", ":Treewalker Down<CR>", opts)
  keymap("n", "<C-k>", ":Treewalker Up<CR>", opts)
  keymap("n", "<C-h>", ":Treewalker Left<CR>", opts)
  keymap("n", "<C-l>", ":Treewalker Right<CR>", opts)

  -- inc-rename.nvim
  keymap("n", "<F2>", function()
    return ":IncRename " .. vim.fn.expand "<cword>"
  end, { expr = true })

  local status_ok, harpoon = pcall(require, "harpoon")

  if status_ok then
    -- TODO: Should be change to our own keymaps
    keymap("n", "<leader>a", function()
      harpoon:list():add()
    end)
    keymap("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    keymap("n", "<C-h>", function()
      harpoon:list():select(1)
    end)
    keymap("n", "<C-t>", function()
      harpoon:list():select(2)
    end)
    keymap("n", "<C-n>", function()
      harpoon:list():select(3)
    end)
    keymap("n", "<C-s>", function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    keymap("n", "<C-S-P>", function()
      harpoon:list():prev()
    end)
    keymap("n", "<C-S-N>", function()
      harpoon:list():next()
    end)
  end

  -- dial.nvim
  keymap("n", "<C-a>", function()
    require("dial.map").manipulate("increment", "normal")
  end)
  keymap("n", "<C-x>", function()
    require("dial.map").manipulate("decrement", "normal")
  end)
  keymap("n", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gnormal")
  end)
  keymap("n", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gnormal")
  end)
  keymap("v", "<C-a>", function()
    require("dial.map").manipulate("increment", "visual")
  end)
  keymap("v", "<C-x>", function()
    require("dial.map").manipulate("decrement", "visual")
  end)
  keymap("v", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gvisual")
  end)
  keymap("v", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gvisual")
  end)
end

return M
