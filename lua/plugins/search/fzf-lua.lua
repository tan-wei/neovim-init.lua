---@type LazyPluginSpec
local M = {
  "ibhagwan/fzf-lua",
  dependencies = {
    {
      "junegunn/fzf",
      build = "./install --bin",
    },
    "nvim-tree/nvim-web-devicons",
    "phanen/fzf-lua-extra",
  },
  cmd = "FzfLua",
}

M.config = function()
  require("fzf-lua").setup {
    winopts = {
      border = "rounded",
      preview = {
        layout = "vertical",
      },
    },
    files = {
      cwd_prompt = false,
    },
    oldfiles = {
      include_current_session = true,
    },
    astgrep = {
      debug = false,
    },
    file_icon_padding = " ",
  }
end

return M
