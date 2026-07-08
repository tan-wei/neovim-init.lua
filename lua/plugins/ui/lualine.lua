---@type LazyPluginSpec
local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "folke/noice.nvim",
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  local lualine = require "lualine"
  local lualine_highlight = require "lualine.highlight"
  local lualine_utils = require "lualine.utils.utils"
  local devicons = require "nvim-web-devicons"
  local has_noice, noice = pcall(require, "noice")
  local has_recorder, recorder = pcall(require, "recorder")
  local indent_icon = devicons.get_icon_by_filetype("editorconfig", { default = true }) or "↹"

  local wider_than = function(width)
    return vim.fn.winwidth(0) > width
  end

  local hide_in_width = function()
    return wider_than(80)
  end

  local function truncate(text, max_len)
    if #text > max_len then
      return text:sub(1, max_len - 1) .. "…"
    end

    return text
  end

  local function badge(component, color)
    local fmt = component.fmt

    local function highlight_name(stl_hl)
      if type(stl_hl) ~= "string" then
        return nil
      end

      return stl_hl:match "^%%#(.-)#$"
    end

    local function rendered_background(group)
      local hl = lualine_utils.extract_highlight_colors(group)
      if type(hl) ~= "table" then
        return nil
      end

      if hl.reverse then
        return hl.fg or hl.bg
      end

      return hl.bg
    end

    return vim.tbl_extend("force", {
      padding = 0,
      color = color or "PmenuSel",
      fmt = function(str, self)
        if fmt then
          str = fmt(str, self)
        end

        if str == nil or str == "" then
          return ""
        end

        local button_hl = self:get_default_hl()
        local section_hl = self.default_hl or lualine_highlight.format_highlight(self.options.self.section)
        local button_group = highlight_name(button_hl)
        local section_group = highlight_name(section_hl)

        if not button_group or not section_group then
          return str
        end

        local button_bg = rendered_background(button_group)
        local section_bg = rendered_background(section_group)

        if not button_bg or not section_bg or button_bg == section_bg then
          return str
        end

        local edge_hl_name = table.concat({
          "lualine_badge_edge",
          self.options.component_name,
          tostring(button_bg):gsub("#", ""),
          tostring(section_bg):gsub("#", ""),
        }, "_")
        lualine_highlight.highlight(edge_hl_name, button_bg, section_bg, nil, nil)

        local edge_hl = "%#" .. edge_hl_name .. "#"
        return table.concat {
          edge_hl,
          "",
          button_hl,
          " ",
          str,
          " ",
          edge_hl,
          "",
        }
      end,
    }, component)
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
    source = function()
      local git_status = vim.b.gitsigns_status_dict
      if git_status == nil then
        return
      end

      local modify_num = git_status.changed
      local remove_num = git_status.removed
      local add_num = git_status.added

      local info = { added = add_num, modified = modify_num, removed = remove_num }
      return info
    end,
  }

  local mode = {
    "mode",
    fmt = function(str)
      return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    colored = true,
    icon_only = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 0,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end

  local spaces = {
    function()
      return indent_icon .. " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end,
    cond = function()
      return wider_than(110)
    end,
  }

  local session = {
    function()
      local auto_session_lib = require "auto-session.lib"
      local session_name = auto_session_lib.current_session_name(true)

      if session_name == "" then
        return ""
      end

      local max_len = wider_than(140) and 28 or wider_than(100) and 18 or 12
      return "󱂬 " .. truncate(session_name, max_len)
    end,
  }

  local function get_harpoon_state()
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then
      return nil
    end

    local list = harpoon:list()
    local length = list:length()
    if length == 0 then
      return {
        harpoon = harpoon,
        list = list,
        length = 0,
        index = nil,
      }
    end

    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
      return {
        harpoon = harpoon,
        list = list,
        length = length,
        index = nil,
      }
    end

    local root = list.config.get_root_dir()
    local relative = require("plenary.path"):new(name):make_relative(root)
    local _, index = list:get_by_value(relative)

    return {
      harpoon = harpoon,
      list = list,
      length = length,
      index = index,
    }
  end

  local function get_multicursor_state()
    local ok, mc = pcall(require, "multicursor-nvim")
    if not ok or not mc.hasCursors() then
      return nil
    end

    return {
      total = mc.numCursors(),
      disabled = mc.numDisabledCursors(),
    }
  end

  local harpoon_status = badge {
    function()
      local state = get_harpoon_state()
      if state == nil or state.length == 0 then
        return ""
      end

      if state.index then
        return string.format("󰀱 %d/%d", state.index, state.length)
      end

      if wider_than(110) then
        return string.format("󰀱 -/%d", state.length)
      end

      return string.format("󰀱 %d", state.length)
    end,
    cond = function()
      local state = get_harpoon_state()
      return state ~= nil and state.length > 0
    end,
    color = function()
      local state = get_harpoon_state()
      if state and state.index then
        return "PmenuSel"
      end

      return "StatusLine"
    end,
    on_click = function(_, mouse_button)
      if mouse_button ~= "l" then
        return
      end

      local state = get_harpoon_state()
      if state == nil then
        return
      end

      vim.schedule(function()
        state.harpoon.ui:toggle_quick_menu(state.list)
      end)
    end,
  }

  local multicursor_status = badge {
    function()
      local state = get_multicursor_state()
      if state == nil then
        return ""
      end

      local parts = { string.format("󰆿 %d", state.total) }
      if state.disabled > 0 then
        parts[#parts + 1] = string.format("󰎀 %d", state.disabled)
      end

      return table.concat(parts, " ")
    end,
    cond = function()
      return get_multicursor_state() ~= nil
    end,
    color = function()
      local state = get_multicursor_state()
      if state and state.disabled > 0 then
        return "Search"
      end

      return "PmenuSel"
    end,
  }

  local colorscheme = badge({
    function()
      local scheme = vim.g.colors_name or "none"

      if not wider_than(95) then
        return ""
      end

      local max_len = wider_than(140) and 16 or 10
      return " " .. truncate(scheme, max_len)
    end,
    on_click = function(_, mouse_button)
      if mouse_button ~= "l" then
        return
      end

      vim.schedule(function()
        local ok, randomizer = pcall(require, "colorscheme-randomizer")
        if not ok then
          return
        end

        randomizer.randomize()
        pcall(function()
          require("lualine").refresh { place = { "statusline" } }
        end)
      end)
    end,
  }, "PmenuSel")

  local project_config = badge({
    function()
      return ""
    end,
    cond = function()
      return vim.g.project_config_local_active == true
    end,
    on_click = function(_, mouse_button)
      if mouse_button ~= "l" then
        return
      end

      local filename = vim.g.project_config_local_file
      if type(filename) ~= "string" or filename == "" then
        return
      end

      vim.schedule(function()
        vim.cmd("edit " .. vim.fn.fnameescape(filename))
      end)
    end,
  }, "PmenuSel")

  local encoding = {
    function()
      return "󰈙 " .. vim.opt.fileencoding:get()
    end,
    cond = function()
      return wider_than(130)
    end,
  }

  local function compact_recorder_recording_status()
    local reg = vim.fn.reg_recording()
    if reg == "" then
      return ""
    end

    if wider_than(120) then
      return " [" .. reg .. "]"
    end

    return " " .. reg
  end

  local function get_current_linters()
    local ok, lint = pcall(require, "lint")
    if not ok or type(lint.linters_by_ft) ~= "table" then
      return {}
    end

    local filetype = vim.bo[0].filetype
    if filetype == "" then
      return {}
    end

    local linters = {}
    local seen = {}

    local function add_linters(ft)
      if ft == nil or ft == "" then
        return
      end

      local configured = lint.linters_by_ft[ft]
      if type(configured) ~= "table" then
        return
      end

      for _, name in ipairs(configured) do
        if not seen[name] then
          seen[name] = true
          table.insert(linters, name)
        end
      end
    end

    add_linters "_"
    add_linters "*"
    add_linters(filetype)

    for _, ft in ipairs(vim.split(filetype, ".", { plain = true, trimempty = true })) do
      add_linters(ft)
    end

    table.sort(linters)

    return linters
  end

  local linter_status = {
    icon = "",
    function()
      local linters = get_current_linters()
      if #linters == 0 then
        return ""
      end

      local max_len = wider_than(160) and 30 or wider_than(120) and 18 or 12
      return truncate(table.concat(linters, ","), max_len)
    end,
    cond = function()
      return #get_current_linters() > 0
    end,
  }

  local noice_components_x = {}

  if has_noice then
    noice_components_x = {
      {
        noice.api.status.command.get,
        cond = noice.api.status.command.has,
        color = { fg = "#ff9e64" },
      },
      {
        noice.api.status.mode.get,
        cond = noice.api.status.mode.has,
        color = { fg = "#ff9e64" },
      },
    }
  end

  local macro_components_c = { "fancy_macro" }
  local macro_components_z = {}

  if has_recorder then
    macro_components_c = {
      {
        function()
          return recorder.displaySlots()
        end,
      },
    }
    macro_components_z = {
      {
        function()
          return compact_recorder_recording_status()
        end,
      },
    }
  end

  local csv_status = {
    function()
      local ok, result = pcall(function()
        if vim.b.current_syntax ~= "csv" then
          return ""
        end

        local line = vim.fn.getline "."
        if line == "" then
          return ""
        end

        -- Grab the first non-empty line as the header.
        local header_line = line
        for i = 1, math.min(vim.fn.line "$", 20) do
          local l = vim.fn.getline(i)
          if l ~= "" then
            header_line = l
            break
          end
        end

        local header = vim.fn.split(header_line, ",", true)
        if #header == 0 then
          return ""
        end

        local fields = vim.fn.split(line, ",", true)
        local cur_col = vim.fn.col "."
        local col_idx = 0
        local pos = 0
        for i, f in ipairs(fields) do
          pos = pos + #f
          if cur_col <= pos then
            col_idx = i - 1
            break
          end
          pos = pos + 1 -- delimiter length
        end
        if cur_col > pos then
          col_idx = #fields - 1
        end

        if col_idx < 0 or col_idx >= #header then
          return ""
        end

        local col_name = header[col_idx + 1]
        local max_len = 40
        if #col_name > max_len then
          col_name = col_name:sub(1, max_len - 1) .. "…"
        end

        return string.format(" %s", col_name)
      end)

      if ok and result and result ~= "" then
        return result
      end
      return ""
    end,
    cond = function()
      return vim.b.current_syntax == "csv"
    end,
    color = function()
      local ok, result = pcall(function()
        if vim.b.current_syntax ~= "csv" then
          return nil
        end

        local line = vim.fn.getline "."
        if line == "" then
          return nil
        end

        local fields = vim.fn.split(line, ",", true)
        local cur_col = vim.fn.col "."
        local col_idx = 0
        local pos = 0
        for i, f in ipairs(fields) do
          pos = pos + #f
          if cur_col <= pos then
            col_idx = i - 1
            break
          end
          pos = pos + 1
        end
        if cur_col > pos then
          col_idx = #fields - 1
        end

        -- Neovim's built-in csv.vim uses csvCol0..csvCol8.
        local num_groups = 0
        while vim.fn.hlexists("csvCol" .. num_groups) == 1 do
          num_groups = num_groups + 1
        end
        if num_groups == 0 then
          return nil
        end

        local group = "csvCol" .. (col_idx % num_groups)
        local hl = vim.api.nvim_get_hl_by_name(group, true)
        if hl and hl.foreground then
          return { fg = string.format("#%06x", hl.foreground) }
        end
        if vim.fn.hlexists(group) == 1 then
          return group
        end
        return nil
      end)

      if ok and result then
        return result
      end
      return { fg = "green" }
    end,
  }

  local config = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "grug-far", "oil" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "fancy_branch", "fancy_diagnostics" },
      lualine_b = { { "fancy_mode", width = 8 } },
      lualine_c = vim.list_extend(
        { "fancy_cwd", project_config, session, harpoon_status, multicursor_status },
        macro_components_c
      ),
      lualine_x = vim.list_extend(
        noice_components_x,
        { csv_status, "overseer", colorscheme, "fancy_searchcount", spaces, encoding, "fancy_filetype" }
      ),
      lualine_y = { "fancy_location", progress },
      lualine_z = vim.list_extend(macro_components_z, { "fancy_lsp_servers", linter_status }),
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "fancy_location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      "aerial",
      "fugitive",
      "fzf",
      "lazy",
      "man",
      "mason",
      "mundo",
      "nvim-dap-ui",
      "nvim-tree",
      "overseer",
      "quickfix",
      "symbols-outline",
      "toggleterm",
      "trouble",
    },
  }

  -- Inserts a component in lualine_c at left section
  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  -- Inserts a component in lualine_x ot right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left {
    "lsp_progress",
    -- With spinner
    -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
    -- colors = {
    --   percentage = colors.cyan,
    --   title = colors.cyan,
    --   message = colors.cyan,
    --   spinner = colors.cyan,
    --   lsp_client_name = colors.magenta,
    --   use = true,
    -- },
    separators = {
      component = " ",
      progress = " | ",
      message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
      percentage = { pre = "", post = "%% " },
      title = { pre = "", post = ": " },
      lsp_client_name = { pre = "[", post = "]" },
      spinner = { pre = "", post = "" },
    },
    display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
    timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
    spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
  }

  lualine.setup(config)
end

return M
