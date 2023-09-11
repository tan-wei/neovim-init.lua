local ok, cybu = pcall(require, "cybu")
if not ok then
  return
end

cybu.setup()
vim.keymap.set("n", "[b", "<Plug>(CybuPrev)")
vim.keymap.set("n", "]b", "<Plug>(CybuNext)")
vim.keymap.set("n", "<s-tab>", "<plug>(CybuLastusedPrev)")
vim.keymap.set("n", "<tab>", "<plug>(CybuLastusedNext)")
