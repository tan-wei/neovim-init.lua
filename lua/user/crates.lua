local status_ok, crates = pcall(require, "crates")
if not status_ok then
  return
end

crates.setup()

local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
  vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
      cmp.setup.buffer { sources = { { name = "crates" } } }
    end,
  })
end
