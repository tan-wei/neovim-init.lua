local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
}

M.config = function()
  local treesitter = require "nvim-treesitter"
  local nvim_treesitter_configs = require "nvim-treesitter.configs"

  nvim_treesitter_configs.setup {
    ensure_installed = "all",
    highlight = {
      enable = true, 
      disable = { "css" }, 
    },
    auto_install = true,
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = {
        "python",
        "css",
      },
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
        clear_on_cursor_move = true,
      },
      highlight_current_scope = {
        enable = false,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
      navigation = {
        enable = true,
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

  local status_ok, nt_cpp_tools = pcall(require, "nt-cpp-tools")
  if status_ok then
    nt_cpp_tools.setup()
  end
end

return M
