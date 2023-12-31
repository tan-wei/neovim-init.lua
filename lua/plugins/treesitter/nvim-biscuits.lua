local M = {
  "code-biscuits/nvim-biscuits",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  enabled = false,
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.opts = {
  default_config = {
    max_length = 12,
    min_distance = 5,
    prefix_string = " 📎 ",
  },
  language_config = {
    html = {
      prefix_string = " 🌐 ",
    },
    javascript = {
      prefix_string = " ✨ ",
      max_length = 80,
    },
    python = {
      disabled = true,
    },
  },
}

return M
