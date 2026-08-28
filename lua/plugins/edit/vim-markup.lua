---@type LazyPluginSpec
local M = {
  "andymass/vim-matchup",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
}

M.init = function()
  vim.g.loaded_matchit = 1
  vim.g.matchup_matchparen_offscreen = { method = "popup", border = "rounded", scrolloff = 1 }
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_hi_surround_always = 1
  vim.g.matchup_matchparen_end_sign = "◀"
  vim.g.matchup_treesitter_disable_virtual_text = false
  local highlight = require "util.highlight"

  local function set_matchup_highlights()
    local accent = highlight.first({ "CurSearch", "IncSearch", "Search", "Visual" }, "bg")
    local match_bg = highlight.first({ "CursorLine", "Visual", "PmenuSel" }, "bg")

    vim.api.nvim_set_hl(0, "MatchParen", { bg = match_bg, sp = accent, underline = true, bold = true })
    vim.api.nvim_set_hl(0, "MatchWord", { bg = match_bg, sp = accent, underline = true, bold = true })
    vim.api.nvim_set_hl(0, "MatchParenCur", { bg = match_bg, sp = accent, underline = true, bold = true })
    vim.api.nvim_set_hl(0, "MatchWordCur", { bg = match_bg, sp = accent, underline = true, bold = true })
    vim.api.nvim_set_hl(0, "MatchBackground", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "MatchupVirtualText", { fg = accent, bg = match_bg, bold = true, nocombine = true })
  end

  set_matchup_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserMatchupHighlights", { clear = true }),
    callback = set_matchup_highlights,
  })
end

return M
