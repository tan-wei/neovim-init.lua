local M = {}

M.setup = function()
  if require("util.os").is_windows() then
    vim.cmd "set guifont=DejaVuSansMono\\ Nerd\\ Font:h12"
  elseif require("util.os").is_macos() then
    vim.cmd "set guifont=DejaVuSansM\\ Nerd\\ Font:h14"
  else
    vim.cmd "set guifont=VictorMono\\ Nerd\\ Font:h8"
  end
end

return M
