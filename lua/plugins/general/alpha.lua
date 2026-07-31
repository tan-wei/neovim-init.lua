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
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("o", "󰍉  Smart open", ":Telescope smart_open <CR>"),
    dashboard.button("p", "  Pickers", ":Telescope builtin include_extensions=true <CR>"),
    dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("z", "  Recently directories", ":Telescope zoxide list <CR>"),
    dashboard.button("s", "󱌣  Session Lens", ":Telescope session-lens <CR>"),
    dashboard.button("t", "󱎸  Find text", ":Telescope live_grep_args live_grep_args theme=ivy <CR>"),
    dashboard.button("c", "  Configuration", string.format(":execute 'cd' fnameescape(%q)<CR>", config_dir)),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }

  local function footer()
    local v = vim.version()
    -- FIXME: datetime is not working on Windows now
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
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
