local M = {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}

M.config = function()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"

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
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    -- dashboard.button("p", "  Find project", ":Telescope projects <CR>"), -- Not that useful, because session is much more useful
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("z", "  Recently directories", ":Telescope zoxide list <CR>"),
    dashboard.button("s", "󱌣  Session Lens", ":Telescope session-lens <CR>"),
    dashboard.button("t", "󱎸  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }

  local function footer()
    local v = vim.version()
    -- FIXME: datetime is not working on Windows now
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    return string.format(
      "%d plugins  %s %d.%d.%d  %s, %d plugins loaded in %d ms",
      stats.count,
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

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

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
