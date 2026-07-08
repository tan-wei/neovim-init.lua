local parsers = require "user.treesitter_parsers"

local highlight_disable = { css = true, csv = true, tsv = true }
local indent_disable = { python = true, css = true }

---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
}

M.config = function()
  -- Migrated from master branch (require("nvim-treesitter.configs").setup) to main branch API.
  -- The main branch dropped the module system entirely. Features previously configured as
  -- modules inside setup {} now must be handled separately:
  --
  -- STILL WORKING (handled below or by their own plugins):
  --   - highlight   → vim.treesitter.start() via FileType autocmd
  --   - indent      → indentexpr via FileType autocmd
  --   - endwise     → nvim-treesitter-endwise works standalone (no config needed)
  --   - matchup     → vim-matchup works standalone (no treesitter module needed)
  --   - autopairs   → handled by the autopairs plugin itself
  --
  -- TEMPORARILY LOST (plugins not yet updated for main branch):
  --   - textsubjects → see nvim-treesitter-textsubjects.lua
  --
  -- PERMANENTLY LOST (plugin archived, replacement not ready):
  --   - refactor     → see nvim-treesitter-refactor.lua
  --
  -- REMOVED (no longer exists in main branch, no equivalent):
  --   - auto_install → removed; use :TSInstall or require("nvim-treesitter").install() instead

  require("nvim-treesitter").setup {}

  if not vim.g.bootstrap_skip_treesitter_install then
    -- Install parsers (replaces ensure_installed, async and no-op if already installed)
    require("nvim-treesitter").install(parsers)
  end

  -- Enable treesitter highlighting and indentation via FileType autocmd
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("NvimTreesitterSetup", { clear = true }),
    callback = function(args)
      local ft = args.match
      if not highlight_disable[ft] then
        pcall(vim.treesitter.start, args.buf)
      end
      if not indent_disable[ft] then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
