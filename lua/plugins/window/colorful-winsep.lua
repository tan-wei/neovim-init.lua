---@type LazyPluginSpec
local M = {
  "nvim-zh/colorful-winsep.nvim",
  dependencies = {
    "mawkler/modicator.nvim",
  },
  event = "VeryLazy",
}

M.opts = {
  border = "rounded",
  highlight = function()
    vim.api.nvim_set_hl(0, "ColorfulWinSep", { link = "CursorLineNr" })
  end,
  excluded_ft = {
    "packer",
    "fzf",
    "mason",
    "NvimTree",
    "alpha",
    "checkhealth",
    "Outline",
    "toggleterm",
    "OverseerList",
    "OverseerForm",
    "qf",
    "help",
    "lazy",
    "noice",
    "notify",
    "trouble",
    "fugitive",
    "neogit",
    "atone",
    "undotree",
    "fzflua_backdrop",
    "dapui_breakpoint",
    "dapui_stacks",
    "dapui_scopes",
    "dapui_console",
    "dapui_watches",
  },
}

M.config = function(_, opts)
  local winsep = require "colorful-winsep"
  local view = require "colorful-winsep.view"
  local render = view.render

  view.render = function()
    if not winsep.enabled or vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end
    if vim.tbl_contains(opts.excluded_ft, vim.bo.filetype) then
      view.hide_all()
      return
    end
    render()
  end

  winsep.setup(opts)
  local events = { "WinEnter", "WinResized", "BufWinEnter" }
  vim.api.nvim_clear_autocmds { group = "colorful_winsep", event = events }
  vim.api.nvim_create_autocmd(events, {
    group = "colorful_winsep",
    callback = function()
      vim.schedule(view.render)
    end,
  })
  vim.schedule(view.render)
end

return M
