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

--   { "christoomey/vim-system-copy" },

--   { "tpope/vim-surround" },
--   { "machakann/vim-sandwich" },

--   -- Git
--   { "rhysd/git-messenger.vim" },
--   { "gregsexton/gitv" },
--   { "jreybert/vimagit" },

-- }

require("lazy").setup {
  spec = {
    { import = "plugins.c++" },
    { import = "plugins.cmp" },
    { import = "plugins.code-runner" },
    { import = "plugins.color" },
    { import = "plugins.colorscheme" },
    { import = "plugins.config" },
    { import = "plugins.csv" },
    { import = "plugins.edit" },
    { import = "plugins.filesystem" },
    { import = "plugins.formatter" },
    { import = "plugins.general" },
    { import = "plugins.git" },
    { import = "plugins.indent" },
    { import = "plugins.keymap" },
    { import = "plugins.linter" },
    { import = "plugins.lsp" },
    { import = "plugins.markdown" },
    { import = "plugins.marks" },
    { import = "plugins.media" },
    { import = "plugins.motion" },
    { import = "plugins.project" },
    { import = "plugins.refactor" },
    { import = "plugins.register" },
    { import = "plugins.rust" },
    { import = "plugins.search" },
    { import = "plugins.snippet" },
    { import = "plugins.task" },
    { import = "plugins.terminal" },
    { import = "plugins.test" },
    { import = "plugins.telescope" },
    { import = "plugins.tool" },
    { import = "plugins.treesitter" },
    { import = "plugins.ui" },
  },
  concurrency = 16,
}
