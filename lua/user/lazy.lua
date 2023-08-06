local fn = vim.fn

-- Automatically install lazy.nvim
local install_path = fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(install_path) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    install_path,
  }
end
vim.opt.rtp:prepend(install_path)

-- Install our plugins here
-- require("lazy").setup {
--   -- General

--   { "junegunn/goyo.vim" },
--   { "junegunn/limelight.vim" },
--   { "mg979/vim-visual-multi", branch = "master" },
--   { "sheerun/vim-polyglot" },
--   { "Pocco81/HighStr.nvim" },
--   { "psliwka/vim-smoothie" },
--   { "inkarkat/vim-mark" },
--   { "christoomey/vim-system-copy" },

--   { "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
--   { "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
--   { "LunarWatcher/auto-pairs" },
--   { "tpope/vim-surround" },
--   { "machakann/vim-sandwich" },
--   { "numToStr/Comment.nvim" },
--   { "JoosepAlviste/nvim-ts-context-commentstring" },
--   { "kyazdani42/nvim-tree.lua" },
--   { "akinsho/bufferline.nvim" },
--   { "moll/vim-bbye" },
--   { "nvim-lualine/lualine.nvim" },
--   { "akinsho/toggleterm.nvim" },
--   { "ahmedkhalf/project.nvim" },
--   { "GnikDroy/projections.nvim" } -- Add this
--   { "lewis6991/impatient.nvim" },
--   { "lukas-reineke/indent-blankline.nvim" },
--   { "goolord/alpha-nvim" },
--   { "folke/which-key.nvim" },

--   -- Colorschemes

--   { "jordwalke/flatlandia" },
--   { "cseelus/vim-colors-lucid" },
--   { "romainl/Apprentice" },
--   { "AlessandroYorba/Alduin" },
--   { "tlhr/anderson.vim" },
--   { "ayu-theme/ayu-vim" },
--   { "NLKNguyen/papercolor-theme" },
--   { "Rigellute/rigel" },
--   { "KeitaNakamura/neodark.vim" },
--   { "liuchengxu/space-vim-dark" },
--   { "jaredgorski/SpaceCamp" },
--   { "arzg/vim-substrata" },
--   { "mhinz/vim-janah" },

--   { "Rigellute/shades-of-purple.vim" },
--   { "kyazdani42/blue-moon" },
--   { "challenger-deep-theme/vim", name = "challenger-deep" },
--   { "zacanger/angr.vim" },
--   { "tyrannicaltoucan/vim-quantum" },
--   { "jnurmine/zenburn" },
--   { "kvrohit/rasmus.nvim" },
--   { "sjl/badwolf" },
--   { "jpo/vim-railscasts-theme" },
--   { "alek3y/Spacegray.vim" },
--   {
--     "sonph/onehalf",
--     config = function(plugin)
--       vim.opt.rtp:append(plugin.dir .. "/vim")
--     end,
--   },
--   { "tjdevries/colorbuddy.nvim" },
--   { "luisiacc/gruvbox-baby", branch = "main" },
--   { "GlennLeo/cobalt2" },
--   { "wuelnerdotexe/vim-enfocado" },
--   { "yonlu/omni.vim" },
--   { "vim-scripts/wombat256.vim" },
--   { "rockerBOO/boo-colorscheme-nvim" },
--   { "windwp/wind-colors" },
--   { "ldelossa/vimdark" },
--   { "rmehri01/onenord.nvim" },
--   { "dikiaap/minimalist" },
--   { "bluz71/vim-nightfly-guicolors" },
--   { "tssm/fairyfloss.vim" },
--   { "phanviet/vim-monokai-pro" },
--   { "ishan9299/nvim-solarized-lua" },
--   { "frenzyexists/aquarium-vim", branch = "develop" },
--   { "preservim/vim-colors-pencil" },
--   { "bluz71/vim-moonfly-colors" },
--   { "yassinebridi/vim-purpura" },
--   { "aonemd/kuroi.vim" },
--   { "glepnir/oceanic-material" },
--   { "yuttie/hydrangea-vim" },
--   { "ntk148v/vim-horizon" },
--   { "yunlingz/ci_dark" },
--   { "mcchrish/zenbones.nvim" },
--   { "rktjmp/lush.nvim" },
--   { "patstockwell/vim-monokai-tasty" },
--   { "nikolvs/vim-sunbather" },
--   { "spf3000/skeletor.vim" },
--   { "beikome/cosme.vim" },
--   { "agude/vim-eldar" },
--   { "pineapplegiant/spaceduck", branch = "main" },
--   { "kaiuri/nvim-juliana" },
--   { "cpea2506/one_monokai.nvim" },
--   { "shaunsingh/moonlight.nvim" },
--   {
--     "kyoz/purify",
--     config = function(plugin)
--       vim.opt.rtp:append(plugin.dir .. "/vim")
--     end,
--   },
--   { "andersevenrud/nordic.nvim" },
--   { "lmburns/kimbox" },
--   { "rhysd/vim-color-spring-night" },
--   { "aktersnurra/no-clown-fiesta.nvim" },
--   { "lewpoly/sherbet.nvim" },
--   { "tiagovla/tokyodark.nvim" },
--   { "NTBBloodbath/doom-one.nvim" },
--   { "fxn/vim-monochrome" },
--   { "rakr/vim-two-firewatch" },
--   { "owickstrom/vim-colors-paramount" },
--   { "JoosepAlviste/palenightfall.nvim" },
--   { "tyrannicaltoucan/vim-deep-space" },
--   { "AlessandroYorba/Sierra" },
--   { "danilo-augusto/vim-afterglow" },
--   { "Mofiqul/adwaita.nvim" },
--   { "rafamadriz/neon" },
--   { "ofirgall/ofirkai.nvim" },
--   { "Everblush/nvim", name = "everblush" },
--   { "kartikp10/noctis.nvim" },
--   { "lifepillar/vim-gruvbox8" },
--   { "rockyzhang24/arctic.nvim" },
--   { "kvrohit/mellow.nvim" },
--   { "uloco/bluloco.nvim" },
--   { "freeo/vim-kalisi" },
--   { "kristijanhusak/vim-hybrid-material" },
--   { "rose-pine/neovim", name = "rose-pine" },
--   { "catppuccin/nvim", name = "catppuccin" },
--   { "romainl/flattened" },
--   { "AhmedAbdulrahman/aylin.vim" },
--   { "Shadorain/shadotheme" },
--   { "raphamorim/lucario" },
--   { "lunacookies/vim-colors-xcode" },
--   { "haishanh/night-owl.vim" },
--   { "gosukiwi/vim-atom-dark" },
--   { "jpo/vim-railscasts-theme" },
--   { "artanikin/vim-synthwave84" },
--   { "wadackel/vim-dogrun" },
--   { "liuchengxu/vista.vim" },

--   -- Cmp
--   { "hrsh7th/nvim-cmp" }, -- The completion plugin
--   { "hrsh7th/cmp-buffer" }, -- buffer completions
--   { "hrsh7th/cmp-path" }, -- path completions
--   { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
--   { "hrsh7th/cmp-nvim-lsp" },
--   { "hrsh7th/cmp-nvim-lua" },

--   -- Snippets
--   { "L3MON4D3/LuaSnip" }, --snippet engine
--   { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

--   -- LSP
--   { "neovim/nvim-lspconfig" }, -- enable LSP
--   { "williamboman/mason.nvim" }, -- simple to language server installer
--   { "williamboman/mason-lspconfig.nvim" },
--   { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
--   { "RRethy/vim-illuminate" },

--   -- Telescope
--   { "nvim-telescope/telescope.nvim" },

--   -- Treesitter
--   { "nvim-treesitter/nvim-treesitter" },

--   -- Git
--   { "airblade/vim-gitgutter" },
--   { "tpope/vim-fugitive" },
--   { "junegunn/gv.vim" },
--   { "rbong/vim-flog" },
--   { "rhysd/git-messenger.vim" },
--   { "gregsexton/gitv" },
--   { "jreybert/vimagit" },

--   -- Markdown
--   { "Scuilion/markdown-drawer" },

--   -- Comment
--   { "tyru/caw.vim" },
--   { "preservim/nerdcommenter" },
--   { "numToStr/Comment.nvim" },

--   -- Misc
--   { "elentok/plaintasks.vim" },

--   -- Coc
--   { "neoclide/coc.nvim", branch = "release" },
--   { "luochen1990/rainbow" },

--   -- Search
--   { "mhinz/vim-grepper" },
--   { "Yggdroot/LeaderF", build = ":LeaderfInstallCExtension" },
--   {
--     "junegunn/fzf",
--     build = function()
--       vim.fn["fzf#install"]()
--     end,
--   },
--   { "junegunn/fzf.vim" },
--   { "gfanto/fzf-lsp.nvim" },
--   { "rhysd/clever-f.vim" },

--   -- Menu
--   { "gelguy/wilder.nvim", build = ":UpdateRemotePlugins" },
--   { "roxma/nvim-yarp" },
--   { "roxma/vim-hug-neovim-rpc" },

--   -- Icons
--   { "ryanoasis/vim-devicons" },
--   { "kyazdani42/nvim-web-devicons" },
--   { "lambdalisue/nerdfont.vim" },

--   -- Highlight
--   { "t9md/vim-quickhl" },
--   { "mtdl9/vim-log-highlighting" },
--   { "nvim-lua/plenary.nvim" },
--   { "folke/todo-comments.nvim" },

--   -- Indent
--   { "Yggdroot/indentLine" },
--   { "lukas-reineke/indent-blankline.nvim" },

--   -- Refactor
--   { "AndrewRadev/splitjoin.vim" },

--   -- Undo
--   {
--     "mbbill/undotree",
--     enabled = function()
--       return vim.fn.has "mac" == 1 or vim.fn.has "mac" == 1
--     end,
--   },
--   {
--     "simnalamburt/vim-mundo",
--     enabled = function()
--       return vim.fn.has "win64" == 1 or vim.fn.has "win32" == 1 or vim.fn.has "win16" == 1
--     end,
--   },

--   -- Align
--   { "junegunn/vim-easy-align" },
--   { "jbyuki/venn.nvim" },
-- }

require("lazy").setup {
  spec = {
    { import = "plugins.general" },
    { import = "plugins.colorscheme" },
    { import = "plugins.treesitter" },
    { import = "plugins.git" },
    { import = "plugins.markdown" },
    { import = "plugins.c++" },
    { import = "plugins.rust" },
    { import = "plugins.lsp" },
    { import = "plugins.cmp" },
    { import = "plugins.snippet" },
    { import = "plugins.keymap" },
    { import = "plugins.formatter" },
    { import = "plugins.linter" },
  },
}
