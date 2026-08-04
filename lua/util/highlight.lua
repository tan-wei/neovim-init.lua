local M = {}

---@param name string
---@param opts? vim.api.keyset.get_hl_info
---@return vim.api.keyset.highlight?
function M.get(name, opts)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, vim.tbl_extend("force", { name = name, link = false }, opts or {}))
  if not ok or vim.tbl_isempty(hl) then
    return nil
  end
  return hl
end

---@param names string[]
---@param key string
---@param fallback? any
---@param opts? vim.api.keyset.get_hl_info
---@return any
function M.first(names, key, fallback, opts)
  for _, name in ipairs(names) do
    local hl = M.get(name, opts)
    if hl and hl[key] ~= nil then
      return hl[key]
    end
  end
  return fallback
end

---@param color? integer
---@return string?
function M.hex(color)
  if color == nil then
    return nil
  end
  return string.format("#%06x", color)
end

---@param names string[]
---@param key string
---@param fallback? string
---@param opts? vim.api.keyset.get_hl_info
---@return string?
function M.first_hex(names, key, fallback, opts)
  return M.hex(M.first(names, key, nil, opts)) or fallback
end

return M
