---@type LazyPluginSpec
local M = {
  "jay-babu/colorscheme-randomizer.nvim",
  tag = "v1.0.0",
  priority = 1000,
}

M.config = function()
  local randomizer = require "colorscheme-randomizer"

  randomizer.setup {
    apply_scheme = false,
    plugin_strategy = "lazy",
    plugins = vim.g.available_colorschemes,
    colorschemes = vim.g.available_colorschemes,
  }

  local pick_random_scheme = randomizer.randomize

  randomizer.randomize = function()
    local scheme = pick_random_scheme()
    if scheme then
      vim.cmd.colorscheme(scheme)
    end
    return scheme
  end

  if randomizer.result.curr_colorscheme then
    vim.cmd.colorscheme(randomizer.result.curr_colorscheme)
  end
end

return M
