local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  event = "VeryLazy",
}

M.config = function()
  local lualine = require "lualine"

  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
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

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  local session = function()
    local auto_session_lib = require "auto-session.lib"
    local session_name = auto_session_lib.current_session_name(true)

    if session_name ~= "" then
      return "session: " .. session_name
    else
      return ""
    end
  end

  local colorscheme = function()
    return "colorscheme: " .. vim.g.colors_name
  end

  local config = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "fancy_branch", "fancy_diagnostics" },
      lualine_b = { { "fancy_mode", width = 8 } },
      lualine_c = { session, "fancy_macro", "lsp_progress" },
      lualine_x = { colorscheme, "overseer", "fancy_searchcount", spaces, "encoding", "fancy_filetype" },
      lualine_y = { "fancy_cwd" },
      lualine_z = { "fancy_lsp_servers", progress },
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
