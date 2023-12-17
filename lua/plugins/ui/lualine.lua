local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
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
    local status_ok, auto_session = pcall(require, "auto-session.lib")
    if not status_ok then
      return nil
    end
    return "session: " .. auto_session.current_session_name()
  end

  local action_hints = function()
    local status_ok, action_hints = pcall(require, "action-hints")
    if not status_ok then
      return nil
    end
    return action_hints.statusline()
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
      lualine_a = { branch, diagnostics },
      lualine_b = { mode },
      lualine_c = { session, "lsp_progress" },
      lualine_x = { action_hints, diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { progress },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
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

  local status_ok, cmake = pcall(require, "cmake-tools")

  if status_ok then
    local icons = require "user.icons"

    ins_left {
      function()
        local c_preset = cmake.get_configure_preset()
        return "CMake: [" .. (c_preset and c_preset or "X") .. "]"
      end,
      icon = icons.ui.Search,
      cond = function()
        return cmake.is_cmake_project() and cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectConfigurePreset"
          end
        end
      end,
    }

    ins_left {
      function()
        local type = cmake.get_build_type()
        return "CMake: [" .. (type and type or "") .. "]"
      end,
      icon = icons.ui.Search,
      cond = function()
        return cmake.is_cmake_project() and not cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectBuildType"
          end
        end
      end,
    }

    ins_left {
      function()
        local kit = cmake.get_kit()
        return "[" .. (kit and kit or "X") .. "]"
      end,
      icon = icons.ui.Pencil,
      cond = function()
        return cmake.is_cmake_project() and not cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectKit"
          end
        end
      end,
    }

    ins_left {
      function()
        return "Build"
      end,
      icon = icons.ui.Gear,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeBuild"
          end
        end
      end,
    }

    ins_left {
      function()
        local b_preset = cmake.get_build_preset()
        return "[" .. (b_preset and b_preset or "X") .. "]"
      end,
      icon = icons.ui.Search,
      cond = function()
        return cmake.is_cmake_project() and cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectBuildPreset"
          end
        end
      end,
    }

    ins_left {
      function()
        local b_target = cmake.get_build_target()
        return "[" .. (b_target and b_target or "X") .. "]"
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectBuildTarget"
          end
        end
      end,
    }

    ins_left {
      function()
        return icons.ui.Debug
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeDebug"
          end
        end
      end,
    }

    ins_left {
      function()
        return icons.ui.Run
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeRun"
          end
        end
      end,
    }

    ins_left {
      function()
        local l_target = cmake.get_launch_target()
        return "[" .. (l_target and l_target or "X") .. "]"
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd "CMakeSelectLaunchTarget"
          end
        end
      end,
    }

    ins_left {
      function()
        return "%="
      end,
    }
  end

  lualine.setup(config)
end

return M
