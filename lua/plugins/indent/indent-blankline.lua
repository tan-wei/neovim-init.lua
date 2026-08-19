---@type LazyPluginSpec
local M = {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  },
  event = { "BufReadPost", "BufNewFile" },
}

M.init = function()
  vim.opt.list = true
  vim.opt.listchars:append "space:⋅"
  vim.opt.listchars:append "eol:↴"
end

M.config = function()
  local rainbow_highlight_groups = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  }
  local rainbow_highlights = {
    RainbowDelimiterRed = { sources = { "RainbowDelimiterRed" }, fallback = 0xE06C75 },
    RainbowDelimiterYellow = { sources = { "RainbowDelimiterYellow" }, fallback = 0xE5C07B },
    RainbowDelimiterBlue = { sources = { "RainbowDelimiterBlue" }, fallback = 0x61AFEF },
    RainbowDelimiterOrange = { sources = { "RainbowDelimiterOrange" }, fallback = 0xD19A66 },
    RainbowDelimiterGreen = { sources = { "RainbowDelimiterGreen" }, fallback = 0x98C379 },
    RainbowDelimiterViolet = { sources = { "RainbowDelimiterViolet" }, fallback = 0xC678DD },
    RainbowDelimiterCyan = { sources = { "RainbowDelimiterCyan" }, fallback = 0x56B6C2 },
  }
  local fallback_whitespace_highlight = "IblWhitespaceFallback"
  local fallback_nontext_highlight = "IblNonTextFallback"
  local notified_missing_highlights = {}
  local highlight = require "util.highlight"

  local function rainbow_highlight_fg(spec)
    if vim.g.rainbow_delimiters_color_strategy == "fixed" then
      return spec.fallback
    end

    return highlight.first(spec.sources, "fg", spec.fallback)
  end

  local function warn_missing_highlights(missing, fallback_details)
    if #missing == 0 then
      return
    end

    local colorscheme = vim.g.colors_name or "unknown"
    local key = table.concat(missing, ",") .. "|" .. table.concat(fallback_details, ",") .. "|" .. colorscheme
    if notified_missing_highlights[key] then
      return
    end
    notified_missing_highlights[key] = true

    vim.schedule(function()
      vim.notify(
        string.format(
          "indent-blankline: missing highlight group(s): %s. Applied fallback colors (%s) for colorscheme '%s'.",
          table.concat(missing, ", "),
          table.concat(fallback_details, ", "),
          colorscheme
        ),
        vim.log.levels.WARN,
        { title = "indent-blankline.nvim" }
      )
    end)
  end

  local ibl = require "ibl"
  local hooks = require "ibl.hooks"

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    for name, spec in pairs(rainbow_highlights) do
      vim.api.nvim_set_hl(0, name, { fg = rainbow_highlight_fg(spec) })
    end

    local missing = {}
    local fallback_details = {}
    local comment_hl = highlight.get "Comment"
    local base_hl = comment_hl
    local base_source = "Comment"
    if not comment_hl then
      base_hl = { fg = "#5C6370" }
      base_source = "hardcoded fallback"
    end

    local whitespace_base = highlight.get "Whitespace"
    local nontext_base = highlight.get "NonText"

    local whitespace_hl = whitespace_base or base_hl
    local nontext_hl = nontext_base or whitespace_base or base_hl

    if not whitespace_base then
      table.insert(missing, "Whitespace")
      table.insert(fallback_details, "Whitespace <- " .. base_source)
    end
    if not nontext_base then
      table.insert(missing, "NonText")
      table.insert(fallback_details, "NonText <- " .. (whitespace_base and "Whitespace" or base_source))
    end

    vim.api.nvim_set_hl(0, fallback_whitespace_highlight, whitespace_hl)
    vim.api.nvim_set_hl(0, fallback_nontext_highlight, nontext_hl)
    warn_missing_highlights(missing, fallback_details)
  end)

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  vim.g.rainbow_delimiters = vim.tbl_deep_extend("force", vim.g.rainbow_delimiters or {}, {
    highlight = rainbow_highlight_groups,
  })

  ibl.setup {
    indent = { char = { "|", "¦", "┆", "┊" }, tab_char = { "»" }, smart_indent_cap = true, priority = 50 },
    scope = {
      show_start = true,
      show_end = true,
      highlight = rainbow_highlight_groups,
      char = { "▏" },
    },
    whitespace = {
      highlight = { fallback_whitespace_highlight, fallback_nontext_highlight },
      remove_blankline_trail = true,
    },
    exclude = {
      filetypes = {
        "",
        "NvimTree",
        "Outline",
        "fzf",
        "fzflua_backdrop",
        "Trouble",
        "Ultest*",
        "alpha",
        "dapui*",
        "dashboard",
        "dbui",
        "floaterm",
        "flutterToolsOutline",
        "fugitive*",
        "git*",
        "help",
        "lazy",
        "log",
        "lspinfo",
        "mason",
        "neogit*",
        "org*",
        "packer",
        "startify",
        "term",
        "undotree",
        "vista",
      },
      buftypes = { "terminal", "nofile" },
    },
  }
end

return M
