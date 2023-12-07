local status_ok, nvim_config_local = pcall(require, "config-local")
if not status_ok then
  return
end

nvim_config_local.setup {
  config_files = {
    ".nvim.lua",
    ".nvimrc",
    ".exrc",
    ".nvim/nvim.lua",
  },
  hashfile = vim.fn.stdpath "data" .. "/config-local",
  autocommands_create = true,
  commands_create = true,
  silent = false,
  lookup_parents = false,
}
