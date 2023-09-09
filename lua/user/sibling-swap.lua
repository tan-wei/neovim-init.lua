local status_ok, sibling_swap = pcall(require, "sibling-swap")
if not status_ok then
  return
end

-- TODO: Configure for sibling-swap.nvim
sibling_swap.setup()
