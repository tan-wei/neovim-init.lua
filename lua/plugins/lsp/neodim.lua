---@type LazyPluginSpec
local M = {
  "zbirenbaum/neodim",
  event = "LspAttach",
}

M.config = function()
  require("neodim").setup {
    refresh_delay = 75,
    alpha = 0.75,
    blend_color = "#000000",
    hide = {
      underline = true,
      virtual_text = true,
      signs = true,
    },
    regex = {
      "[uU]nused",
      "[nN]ever [rR]ead",
      "[nN]ot [rR]ead",
    },
    priority = 128,
    disable = {
      "NvimTree",
      "Outline",
      "qf",
      "help",
      "toggleterm",
      "lazy",
      "mason",
      "alpha",
      "checkhealth",
      "noice",
      "notify",
      "fugitive",
      "neogit",
      "undotree",
      "trouble",
      "TelescopePrompt",
      "TelescopeResults",
      "dapui_breakpoint",
      "dapui_stacks",
      "dapui_scopes",
      "dapui_console",
      "dapui_watches",
    },
  }
end

return M
