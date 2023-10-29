local status_ok, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

local treesitter = require "nvim-treesitter"

nvim_treesitter_configs.setup {
  ensure_installed = {
    "c",
    "cpp",
    "csv",
    "vim",
    "rust",
    "ruby",
    "lua",
    "markdown",
    "markdown_inline",
    "bash",
    "python",
    "toml",
    "cmake",
    "doxygen",
    "yaml",
    "json",
    "dot",
    "capnp",
    "tsv",
  }, -- put the language you want in this array
  -- ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
  },
  auto_install = true,

  autopairs = {
    enable = true,
  },

  autotag = {
    enable = true,
  },

  indent = { enable = true, disable = { "python", "css" } },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  textsubjects = {
    enable = true,
    prev_selection = ",",
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },

  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
    matchup = {
      enable = true,
      disable = {},
      disable_virtual_text = false,
      include_match_words = true,
    },
  },
}

local status_ok, treesitter_context = pcall(require, "treesitter-context")
if status_ok then
  treesitter_context.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  }
end

local status_ok, nt_cpp_tools = pcall(require, "nt-cpp-tools")
if status_ok then
  nt_cpp_tools.setup()
end
