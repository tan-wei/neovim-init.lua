---@diagnostic disable: undefined-global

local M = {}

local repo_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")

---@type table<string, string[]>
local errors = {
  not_found = {},
  no_colors_name = {},
  duplicate = {},
}

function M.check()
  local available = vim.g.available_colorschemes
  if not available or type(available) ~= "table" or #available == 0 then
    print "OK: no colorschemes registered in vim.g.available_colorschemes"
    return
  end

  -- Check for duplicates before any sorting
  local seen = {}
  for _, name in ipairs(available) do
    if seen[name] then
      table.insert(errors.duplicate, name)
    end
    seen[name] = true
  end

  if #errors.duplicate > 0 then
    print "  FAIL  Duplicate colorscheme name(s) found — the later one would shadow the earlier:"
    for _, name in ipairs(errors.duplicate) do
      print(string.format("    " .. name))
    end
  end

  -- Sort for deterministic output
  table.sort(available)

  local total = #available
  local passed = 0

  for _, name in ipairs(available) do
    -- Clear colors_name before setting, so we can detect if the colorscheme
    -- fails to set its own (e.g. inherits from a previously loaded one)
    vim.g.colors_name = nil
    vim.v.errmsg = ""
    local ok, err = pcall(vim.cmd.colorscheme, name)

    if not ok then
      table.insert(errors.not_found, name)
      print(string.format("  FAIL  %s  —  colorscheme not found: %s", name, tostring(err):gsub("\n.*", "")))
    elseif vim.g.colors_name == nil or vim.g.colors_name == "" then
      table.insert(errors.no_colors_name, name)
      print(string.format("  FAIL  %s  —  vim.g.colors_name is empty/nil after setting", name))
    else
      passed = passed + 1
      print(string.format("  PASS  %s  →  %s", name, vim.g.colors_name))
    end
  end

  print ""
  print(string.format("Results: %d/%d passed, %d failed", passed, total, total - passed))

  if #errors.not_found > 0 then
    print ""
    print "Colorschemes that could not be loaded:"
    for _, name in ipairs(errors.not_found) do
      print("  - " .. name)
    end
  end

  if #errors.no_colors_name > 0 then
    print ""
    print "Colorschemes that loaded but left vim.g.colors_name empty:"
    for _, name in ipairs(errors.no_colors_name) do
      print("  - " .. name)
    end
  end

  if #errors.duplicate > 0 or #errors.not_found > 0 or #errors.no_colors_name > 0 then
    local total_errors = #errors.duplicate + #errors.not_found + #errors.no_colors_name
    error(string.format("colorscheme-check: %d colorscheme(s) failed validation", total_errors))
  end

  print "All colorschemes validated successfully."
end

return M
