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
        else
          local remote_unix_socket = vim.env.WEZTERM_UNIX_SOCKET
          local ret = try_address(remote_unix_socket, true)
          if ret ~= nil then
            return ret
          end
        end
      end
    end,
    one_per = {
      kitty = is_kitty,
      wezterm = is_wezterm,
    },
  }
end

M.opts = {}

return M
