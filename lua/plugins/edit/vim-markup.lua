---@type LazyPluginSpec
local M = {
  "andymass/vim-matchup",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- event = "BufReadPost", -- FIXME: Any lazy load will cause problem
}

M.init = function()
  vim.g.loaded_matchit = 1
  vim.g.matchup_matchparen_offscreen = { method = "popup", border = "rounded", scrolloff = 1 }
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_hi_surround_always = 1
  vim.g.matchup_matchparen_end_sign = "◀"
  vim.g.matchup_treesitter_disable_virtual_text = false

  local function get_highlight(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if not ok or vim.tbl_isempty(hl) then
      return nil
    end
    return hl
  end

  local function first_highlight_value(names, key, fallback)
    for _, name in ipairs(names) do
      local hl = get_highlight(name)
      if hl and hl[key] then
        return hl[key]
      end
    end
    return fallback
  end

  local function set_matchup_highlights()
    local accent = first_highlight_value({ "CurSearch", "IncSearch", "Search", "Visual" }, "bg", nil)
    local match_bg = first_highlight_value({ "CursorLine", "Visual", "PmenuSel" }, "bg", nil)

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
