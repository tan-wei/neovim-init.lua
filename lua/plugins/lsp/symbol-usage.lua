local M = {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach",
}

M.config = function()
  local symbol_usage = require "symbol-usage"

  local function h(name)
    return vim.api.nvim_get_hl(0, { name = name })
  end

  local function plain_text_format(symbol)
    local fragments = {}

    if symbol.references then
      local usage = symbol.references <= 1 and "usage" or "usages"
      local num = symbol.references == 0 and "no" or symbol.references
      table.insert(fragments, ("%s %s"):format(num, usage))
    end

    if symbol.definition then
      table.insert(fragments, symbol.definition .. " defs")
    end

    if symbol.implementation then
      table.insert(fragments, symbol.implementation .. " impls")
    end

    return table.concat(fragments, ", ")
  end

  local function bubble_text_format(symbol)
    -- TODO: Every time colorscheme should refresh
    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

    local res = {}

    local round_start = { "", "SymbolUsageRounding" }
    local round_end = { "", "SymbolUsageRounding" }

    if symbol.references then
      local usage = symbol.references <= 1 and "usage" or "usages"
      local num = symbol.references == 0 and "no" or symbol.references
      table.insert(res, round_start)
      table.insert(res, { "󰌹 ", "SymbolUsageRef" })
      table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.definition then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰳽 ", "SymbolUsageDef" })
      table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.implementation then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
      table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    return res
  end

  local function label_text_format(symbol)
    -- TODO: Every time colorscheme should refresh
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { bg = h("Type").fg, fg = h("Normal").bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRefRound", { fg = h("Type").fg })

    vim.api.nvim_set_hl(0, "SymbolUsageDef", { bg = h("Function").fg, fg = h("Normal").bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDefRound", { fg = h("Function").fg })

    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { bg = h("@parameter").fg, fg = h("Normal").bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImplRound", { fg = h("@parameter").fg })

    local res = {}

    local round_start = { "", "SymbolUsageRounding" }
    local round_end = { "", "SymbolUsageRounding" }

    if symbol.references then
      local usage = symbol.references <= 1 and "usage" or "usages"
      local num = symbol.references == 0 and "no" or symbol.references
      table.insert(res, round_start)
      table.insert(res, { "󰌹 ", "SymbolUsageRef" })
      table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.definition then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰳽 ", "SymbolUsageDef" })
      table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    if symbol.implementation then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, round_start)
      table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
      table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
      table.insert(res, round_end)
    end

    return res
  end

  local text_format_according_term = function(symbol)
    if vim.env.TERM == "xterm-256color" then
      return plain_text_format(symbol)
    elseif vim.env.TERM == "wezterm" then
      return bubble_text_format(symbol)
    elseif vim.env.TERM == "kitty" then
      return bubble_text_format(symbol)
    elseif not vim.env.TERM or vim.env.TERM == "" then
      -- Use GUI
      if vim.g.neovide then
        return bubble_text_format(symbol)
      else
        return plain_text_format(symbol)
      end
    end
  end

  symbol_usage.setup {
    hl = { link = "Comment" },
    kinds_filter = {},
    vt_position = "above",
    request_pending_text = "loading...",
    references = { enabled = true, include_declaration = false },
    definition = { enabled = true },
    implementation = { enabled = true },
    text_format = text_format_according_term,
  }
end

return M
