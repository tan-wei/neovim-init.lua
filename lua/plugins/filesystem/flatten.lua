local M = {
  "willothy/flatten.nvim",
  lazy = false,
  priority = 1001,
}
local try_address = function(addr, startserver)
  if not addr:find "/" then
    addr = ("%s/%s"):format(vim.fn.stdpath "run", addr)
  end
  if vim.loop.fs_stat(addr) then
    local ok, sock = require("flatten.guest").sockconnect(addr)
    if ok then
      return sock
    end
  elseif startserver then
    local ok = pcall(vim.fn.serverstart, addr)
    if ok then
      return addr
    end
  end
end

M.config = function()
  local is_kitty = require("util.client").is_kitty()
  local is_wezterm = require("util.client").is_wezterm()
  local saved_terminal = nil

  require("flatten").setup {
    pipe_path = function()
      -- If running in a terminal inside Neovim:
      if vim.env.NVIM then
        return vim.env.NVIM
      end

      if is_kitty and vim.env.KITTY_PID then
        local ret = try_address("kitty.nvim-" .. vim.env.KITTY_PID, true)
        if ret ~= nil then
          return ret
        end
      end

      if is_wezterm and vim.env.WEZTERM_UNIX_SOCKET then
        local pid = vim.env.WEZTERM_UNIX_SOCKET:match "gui%-sock%-(%d+)"
        if pid then
          local ret = try_address("wezterm.nvim-" .. pid, true)
          if ret ~= nil then
            return ret
          end
        end
      end
    end,
    window = {
      open = "alternate",
    },
    hooks = {
      should_block = function(argv)
        return vim.tbl_contains(argv, "-b")
      end,
      pre_open = function()
        local term = require "toggleterm.terminal"
        local termid = term.get_focused_id()
        saved_terminal = term.get(termid)
      end,
      post_open = function(bufnr, winnr, ft, is_blocking)
        if is_blocking and saved_terminal then
          saved_terminal:close()
        else
          vim.api.nvim_set_current_win(winnr)

          require("wezterm").switch_pane.id(tonumber(os.getenv "WEZTERM_PANE"))
        end

        if ft == "gitcommit" or ft == "gitrebase" then
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            once = true,
            callback = vim.schedule_wrap(function()
              vim.api.nvim_buf_delete(bufnr, {})
            end),
          })
        end
      end,
      block_end = function()
        vim.schedule(function()
          if saved_terminal then
            saved_terminal:open()
            saved_terminal = nil
          end
        end)
      end,
    },
    integrations = {
      kitty = is_kitty,
      wezterm = is_wezterm,
    },
  }
end

M.opts = {}

return M
