---@type LazyPluginSpec
local M = {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}

M.config = function()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  local config_dir = vim.fn.stdpath "config"

  dashboard.section.header.val = {
    [[                                                                    ]],
    [[       ████ ██████           █████      ██                    ]],
    [[      ███████████             █████                            ]],
    [[      █████████ ███████████████████ ███   ███████████  ]],
    [[     █████████  ███    █████████████ █████ ██████████████  ]],
    [[    █████████ ██████████ █████████ █████ █████ ████ █████  ]],
    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████]],
  }
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find file", ":FzfLua files <CR>"),
    dashboard.button("o", "󰍉  Smart open", ":lua require('fzf-lua-frecency').frecency({ cwd_only = true })<CR>"),
    dashboard.button("p", "  Pickers", ":FzfLua builtin <CR>"),
    dashboard.button("r", "  Recently used files", ":FzfLua oldfiles <CR>"),
    dashboard.button("z", "  Recently directories", ":FzfLua zoxide <CR>"),
    dashboard.button("s", "󱌣  Session picker", ":AutoSession search <CR>"),
    dashboard.button("t", "󱎸  Find text", ":FzfLua live_grep <CR>"),
    dashboard.button("c", "  Configuration", string.format(":execute 'cd' fnameescape(%q)<CR>", config_dir)),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }

  local function footer()
    local v = vim.version()
    -- FIXME: datetime is not working on Windows now
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local os = require "util.os"
    local platform = os.is_windows() and "" or os.is_macos() and "" or ""
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    return string.format(
      "%d plugins %d colorschemes  %s   %d.%d.%d  %s, %d plugins loaded in %d ms",
      stats.count,
      #vim.g.available_colorschemes,
      platform,
      v.major,
      v.minor,
      v.patch,
      datetime,
      stats.loaded,
      ms
    )
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Comment"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "Keyword"
    button.opts.hl_shortcut = "Number"
  end

  dashboard.opts.opts.noautocmd = true
  -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
  alpha.setup(dashboard.opts)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = footer()
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return M
