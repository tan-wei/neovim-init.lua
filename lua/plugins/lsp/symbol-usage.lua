local M = {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach",
}

M.config = function()
  local symbol_usage = require "symbol-usage"
  local symbol_usage_state = require "symbol-usage.state"
  local client = require "util.client"

  local function h(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if not ok or vim.tbl_isempty(hl) then
      return {}
    end
    return hl
  end

  local function hl_value(names, key)
    for _, name in ipairs(names) do
      local value = h(name)[key]
      if value ~= nil then
        return value
      end
    end
  end

  local function refresh_bubble_highlights()
    local cursorline_bg = hl_value({ "CursorLine", "CursorColumn", "ColorColumn", "Normal" }, "bg")
    local content_fg = hl_value({ "Comment", "NonText", "Normal" }, "fg")
    local ref_fg = hl_value({ "Function", "@function", "Identifier", "Comment" }, "fg")
    local def_fg = hl_value({ "Type", "@type", "Identifier", "Comment" }, "fg")
    local impl_fg = hl_value({ "@keyword", "Keyword", "Statement", "Comment" }, "fg")

    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = cursorline_bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = cursorline_bg, fg = content_fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = ref_fg, bg = cursorline_bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = def_fg, bg = cursorline_bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = impl_fg, bg = cursorline_bg, italic = true })
  end

  local function refresh_label_highlights()
    local normal_bg = hl_value({ "Normal", "NormalFloat", "CursorLine" }, "bg")
    local ref_bg = hl_value({ "Type", "@type", "Identifier", "Comment" }, "fg")
    local def_bg = hl_value({ "Function", "@function", "Identifier", "Comment" }, "fg")
    local impl_bg = hl_value({ "@parameter", "@keyword", "Identifier", "Comment" }, "fg")

    vim.api.nvim_set_hl(0, "SymbolUsageRef", { bg = ref_bg, fg = normal_bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRefRound", { fg = ref_bg })

    vim.api.nvim_set_hl(0, "SymbolUsageDef", { bg = def_bg, fg = normal_bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDefRound", { fg = def_bg })

    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { bg = impl_bg, fg = normal_bg, bold = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImplRound", { fg = impl_bg })
  end

  local function refresh_renderer_highlights()
    local refreshers = {
      ["neovide"] = refresh_bubble_highlights,
      ["wezterm"] = refresh_bubble_highlights,
      ["kitty"] = refresh_bubble_highlights,
      ["ghostty"] = refresh_label_highlights,
    }

    local refresher = refreshers[client.get_client()]
    if refresher then
      refresher()
    end
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
    local res = {}

    -- Indicator that shows if there are any other symbols in the same line
    local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

    if symbol.references then
      table.insert(res, { "󰍞", "SymbolUsageRefRound" })
      table.insert(res, { "󰌹 " .. tostring(symbol.references), "SymbolUsageRef" })
      table.insert(res, { "󰍟", "SymbolUsageRefRound" })
    end

    if symbol.definition then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, { "󰍞", "SymbolUsageDefRound" })
      table.insert(res, { "󰳽 " .. tostring(symbol.definition), "SymbolUsageDef" })
      table.insert(res, { "󰍟", "SymbolUsageDefRound" })
    end

    if symbol.implementation then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, { "󰍞", "SymbolUsageImplRound" })
      table.insert(res, { "󰡱 " .. tostring(symbol.implementation), "SymbolUsageImpl" })
      table.insert(res, { "󰍟", "SymbolUsageImplRound" })
    end

    if stacked_functions_content ~= "" then
      if #res > 0 then
        table.insert(res, { " ", "NonText" })
      end
      table.insert(res, { "󰍞", "SymbolUsageImplRound" })
      table.insert(res, { " " .. tostring(stacked_functions_content), "SymbolUsageImpl" })
      table.insert(res, { "󰍟", "SymbolUsageImplRound" })
    end

    return res
  end

  local text_format_according_term = function(symbol)
    local client_map = {
      ["neovide"] = bubble_text_format,
      ["neovim-qt"] = plain_text_format,
      ["wezterm"] = bubble_text_format,
      ["kitty"] = bubble_text_format,
      ["ghostty"] = label_text_format,
      ["alacritty"] = plain_text_format,
      ["default"] = plain_text_format,
    }

    local renderer = client_map[client.get_client()] or plain_text_format

    return renderer(symbol)
  end

  symbol_usage.setup {
    hl = { link = "Comment" },
    kinds_filter = {},
    vt_position = "above",
    -- request_pending_text = "loading...",
    request_pending_text = false, -- TODO: Due to buggy use neovide or neovim-qt
    references = { enabled = true, include_declaration = false },
    definition = { enabled = true },
    implementation = { enabled = true },
    text_format = text_format_according_term,
  }

  refresh_renderer_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("SymbolUsageCustomHighlights", { clear = true }),
    callback = function()
      refresh_renderer_highlights()

      if next(symbol_usage_state.get_buf_workers(vim.api.nvim_get_current_buf())) ~= nil then
        vim.schedule(function()
          symbol_usage.refresh()
        end)
      end
    end,
  })
end

return M
