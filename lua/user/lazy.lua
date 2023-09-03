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

--   { "tpope/vim-surround" },
--   { "machakann/vim-sandwich" },
--   { "JoosepAlviste/nvim-ts-context-commentstring" },
--   { "GnikDroy/projections.nvim" } -- Add this

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
--   { "challenger-deep-theme/vim", name = "challenger-deep" },
--   { "zacanger/angr.vim" },
--   { "tyrannicaltoucan/vim-quantum" },
--   { "jnurmine/zenburn" },
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
--   { "GlennLeo/cobalt2" },
--   { "vim-scripts/wombat256.vim" },
--   { "windwp/wind-colors" },
--   { "ldelossa/vimdark" },
--   { "tssm/fairyfloss.vim" },
--   { "phanviet/vim-monokai-pro" },
--   { "preservim/vim-colors-pencil" },
--   { "yassinebridi/vim-purpura" },
--   { "aonemd/kuroi.vim" },
--   { "glepnir/oceanic-material" },
--   { "ntk148v/vim-horizon" },
--   { "yunlingz/ci_dark" },
--   { "patstockwell/vim-monokai-tasty" },
--   { "nikolvs/vim-sunbather" },
--   { "spf3000/skeletor.vim" },
--   { "beikome/cosme.vim" },
--   { "agude/vim-eldar" },
--   { "pineapplegiant/spaceduck", branch = "main" },
--   {
--     "kyoz/purify",
--     config = function(plugin)
--       vim.opt.rtp:append(plugin.dir .. "/vim")
--     end,
--   },
--   { "freeo/vim-kalisi" },
--   { "kristijanhusak/vim-hybrid-material" },
--   { "romainl/flattened" },
--   { "AhmedAbdulrahman/aylin.vim" },
--   { "raphamorim/lucario" },
--   { "haishanh/night-owl.vim" },

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

--   -- Icons
--   { "ryanoasis/vim-devicons" },
--   { "kyazdani42/nvim-web-devicons" },
--   { "lambdalisue/nerdfont.vim" },

--   -- Highlight
--   { "t9md/vim-quickhl" },
--   { "mtdl9/vim-log-highlighting" },
--   { "nvim-lua/plenary.nvim" },
--   { "folke/todo-comments.nvim" },

--   -- Refactor
--   { "AndrewRadev/splitjoin.vim" },

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
    { import = "plugins.test" },
    { import = "plugins.ui" },
    { import = "plugins.code-runner" },
  },
  concurrency = 8,
}
