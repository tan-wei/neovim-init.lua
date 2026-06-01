---@type LazyPluginSpec
local M = {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "VeryLazy",
}

M.config = function()
  local mc = require "multicursor-nvim"
  mc.setup()

  local set = vim.keymap.set

  local function refresh_lualine()
    local ok, lualine = pcall(require, "lualine")
    if ok then
      lualine.refresh { place = { "statusline" } }
    end
  end

  local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok then
      return hl
    end
    return {}
  end

  local function first_hl_color(names, key, fallback)
    for _, name in ipairs(names) do
      local value = get_hl(name)[key]
      if value ~= nil then
        return value
      end
    end
    return fallback
  end

  -- Add or skip cursor above/below the main cursor.
  set({ "n", "x" }, "<up>", function()
    mc.lineAddCursor(-1)
  end)
  set({ "n", "x" }, "<down>", function()
    mc.lineAddCursor(1)
  end)
  set({ "n", "x" }, "<leader><up>", function()
    mc.lineSkipCursor(-1)
  end)
  set({ "n", "x" }, "<leader><down>", function()
    mc.lineSkipCursor(1)
  end)

  -- Add or skip adding a new cursor by matching word/selection
  set({ "n", "x" }, "]m", function()
    mc.matchAddCursor(1)
  end)
  set({ "n", "x" }, "]M", function()
    mc.matchSkipCursor(1)
  end)
  set({ "n", "x" }, "[m", function()
    mc.matchAddCursor(-1)
  end)
  set({ "n", "x" }, "[M", function()
    mc.matchSkipCursor(-1)
  end)

  -- Add and remove cursors with control + left click.
  set("n", "<c-leftmouse>", mc.handleMouse)
  set("n", "<c-leftdrag>", mc.handleMouseDrag)
  set("n", "<c-leftrelease>", mc.handleMouseRelease)

  -- Disable and enable cursors.
  set({ "n", "x" }, "<A-q>", mc.toggleCursor)

  -- Mappings defined in a keymap layer only apply when there are
  -- multiple cursors. This lets you have overlapping mappings.
  mc.addKeymapLayer(function(layerSet)
    -- Select a different cursor as the main one.
    layerSet({ "n", "x" }, "<left>", mc.prevCursor)
    layerSet({ "n", "x" }, "<right>", mc.nextCursor)

    -- Delete the main cursor.
    layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      else
        mc.clearCursors()
      end
    end)
  end)

  -- Customize how cursors look.
  local function set_multicursor_highlights()
    local hl = vim.api.nvim_set_hl
    local normal = get_hl "Normal"
    local cursor_bg = first_hl_color({ "CurSearch", "IncSearch", "Search", "Visual" }, "bg", 0xFFAF5F)
    local cursor_fg = first_hl_color({ "CurSearch", "IncSearch", "Search" }, "fg", normal.bg)
    local visual_bg = first_hl_color({ "Visual", "CursorLine", "Search" }, "bg", 0x3A3F58)
    local disabled_bg = first_hl_color({ "PmenuSel", "StatusLine", "CursorLine", "Visual" }, "bg", 0x6C7086)
    local disabled_fg = first_hl_color({ "PmenuSel", "StatusLine", "Visual" }, "fg", normal.bg)
    local preview_bg = first_hl_color({ "Search", "IncSearch", "CurSearch" }, "bg", cursor_bg)
    local preview_fg = first_hl_color({ "Search", "IncSearch", "CurSearch" }, "fg", normal.bg)

    hl(0, "MultiCursorCursor", {
      fg = cursor_fg,
      bg = cursor_bg,
      bold = true,
      nocombine = true,
    })
    hl(0, "MultiCursorVisual", {
      bg = visual_bg,
      nocombine = true,
    })
    hl(0, "MultiCursorSign", {
      fg = cursor_bg,
      nocombine = true,
    })
    hl(0, "MultiCursorMatchPreview", {
      fg = preview_fg,
      bg = preview_bg,
      bold = true,
      nocombine = true,
    })
    hl(0, "MultiCursorDisabledCursor", {
      fg = disabled_fg,
      bg = disabled_bg,
      nocombine = true,
    })
    hl(0, "MultiCursorDisabledVisual", {
      bg = disabled_bg,
      nocombine = true,
    })
    hl(0, "MultiCursorDisabledSign", {
      fg = disabled_bg,
      nocombine = true,
    })
  end

  set_multicursor_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserMultiCursorHighlights", { clear = true }),
    callback = set_multicursor_highlights,
  })

  -- NOTE: Ensure refresh lualine
  mc.onSafeState(refresh_lualine)
end

return M
