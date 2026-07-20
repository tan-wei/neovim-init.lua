--- Treesitter Parser Audit
---
--- Reports the relationship between upstream (nvim-treesitter), configured parsers,
--- and actually installed parsers:
---
---   ✓ Installed & configured parsers
---   ? New upstream parsers we haven't added to our config     (→ should add to config)
---   ✗ Configured parsers removed from upstream                (→ should remove from config)
---   ! Configured parsers with install_info but not installed  (→ should install)
---   ~ Parsers without install_info (cannot be installed)      (→ informational, still tracked)
---
--- Usage:
---   nvim --headless --cmd "{{bootstrap_preinit}}" "+lua dofile('scripts/treesitter_audit.lua').check()" +qa!
---
--- The script fails (exit 1) if there are:
---   - Removed parsers (should clean up config)
---   - New upstream parsers with install_info (should add to config)
---   - Not-installed parsers with install_info (should install)
---   - New upstream parsers without install_info (should add to config for completeness)

local M = {}

---@return string[]
local function get_upstream_parsers()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return {}
  end
  local names = {}
  for name, spec in pairs(parsers) do
    if type(spec) == "table" then
      table.insert(names, name)
    end
  end
  table.sort(names)
  return names
end

---@return string[]
local function get_installed_parsers()
  -- Try the new nvim-treesitter main branch API first, then fallback.
  local ok, ts = pcall(require, "nvim-treesitter")
  if ok and ts.get_installed then
    local installed = ts.get_installed "parsers"
    if type(installed) == "table" then
      return installed
    end
  end

  -- Fallback: vim.treesitter
  local list = vim.treesitter.list or vim.treesitter.available_parsers
  if type(list) == "table" then
    return list
  end
  if type(list) == "function" then
    return list()
  end
  return {}
end

---@param t string[]
---@return table<string,boolean>
local function index(t)
  local idx = {}
  for _, v in ipairs(t) do
    idx[v] = true
  end
  return idx
end

local function divider()
  print(string.rep("-", 72))
end

local function warn(msg)
  print("WARNING: " .. msg)
end

function M.check()
  -- Load our configured parsers
  local ok, our_parsers = pcall(require, "user.treesitter_parsers")
  if not ok or type(our_parsers) ~= "table" then
    warn "Could not load user.treesitter_parsers"
    os.exit(1)
  end

  -- Get all parsers known to nvim-treesitter
  local upstream = get_upstream_parsers()

  -- Compute the list of installable parsers from our config
  local ok2, parsers_mod = pcall(require, "nvim-treesitter.parsers")
  local has_install_info = {}
  local installable_from_config = {}
  if ok2 then
    for name, spec in pairs(parsers_mod) do
      has_install_info[name] = type(spec) == "table" and spec.install_info ~= nil
    end
    for _, p in ipairs(our_parsers) do
      if has_install_info[p] then
        table.insert(installable_from_config, p)
      end
    end
  end

  -- Get installed parsers from nvim-treesitter
  local installed = get_installed_parsers()
  table.sort(installed)

  -- If we're in a CI environment and nothing is installed, re-trigger sync
  -- This handles the case where build/compile was still in progress when
  -- the previous nvim process exited.
  local is_ci = os.getenv "CI" ~= nil
  local installable_count = #installable_from_config
  local attempts = 0
  local max_attempts = is_ci and 30 or 1
  while attempts < max_attempts do
    local missing_count = 0
    for _, p in ipairs(installable_from_config) do
      if not vim.tbl_contains(installed, p) then
        missing_count = missing_count + 1
      end
    end
    if missing_count == 0 then
      break
    end
    if attempts == 0 and is_ci then
      print(string.format(
        "  Wait: %d/%d installable parsers missing, retrying...",
        missing_count, installable_count
      ))
    end
    attempts = attempts + 1
    vim.wait(1000)
    installed = get_installed_parsers()
    table.sort(installed)
  end
  if attempts > 0 then
    installed = get_installed_parsers()
    table.sort(installed)
  end

  local upstream_set = index(upstream)
  local our_set = index(our_parsers)
  local installed_set = index(installed)

  local all_parsers = {}
  for _, p in ipairs(upstream) do
    all_parsers[p] = true
  end
  for _, p in ipairs(our_parsers) do
    all_parsers[p] = true
  end
  for _, p in ipairs(installed) do
    all_parsers[p] = true
  end

  local sorted_all = vim.tbl_keys(all_parsers)
  table.sort(sorted_all)

  -- Categories
  local installed_configured = {} -- upstream + our + installed
  local new_upstream = {} -- upstream but not our
  local removed = {} -- our but not upstream
  local not_installed = {} -- our + upstream but not installed
  local not_installed_trackers = {} -- subset: no install_info, informational only

  for _, parser in ipairs(sorted_all) do
    local in_upstream = upstream_set[parser]
    local in_our = our_set[parser]
    local in_installed = installed_set[parser]

    if in_upstream and in_our and in_installed then
      table.insert(installed_configured, parser)
    elseif in_upstream and not in_our then
      table.insert(new_upstream, parser)
    elseif in_our and not in_upstream then
      table.insert(removed, parser)
    elseif in_our and in_upstream and not in_installed then
      table.insert(not_installed, parser)
      if not has_install_info[parser] then
        table.insert(not_installed_trackers, parser)
      end
    end
  end

  -- === Report ===
  print ""
  divider()
  print "  Treesitter Parser Audit"
  divider()
  print ""

  -- 1) Installed & Configured
  print "  [Installed & Configured]"
  for _, parser in ipairs(installed_configured) do
    print(string.format("    ✓ %s", parser))
  end
  print(string.format("    Total: %d", #installed_configured))
  print ""

  -- 2) New upstream parsers not in our config
  if #new_upstream > 0 then
    print "  [New Upstream Parsers — Not Configured]"
    for _, parser in ipairs(new_upstream) do
      if installed_set[parser] then
        print(string.format("    ? %s (already installed)", parser))
      elseif has_install_info[parser] then
        print(string.format("    ? %s (not installed, should add to config)", parser))
      else
        print(string.format("    ~ %s (not installable, should add to config for completeness)", parser))
      end
    end
    print(string.format("    Total: %d", #new_upstream))
    print ""
  end

  -- 3) Configured parsers no longer in upstream
  if #removed > 0 then
    print "  [Configured Parsers No Longer in Upstream — SHOULD REMOVE]"
    for _, parser in ipairs(removed) do
      if installed_set[parser] then
        print(string.format("    ✗ %s (installed, but upstream removed it)", parser))
      else
        print(string.format("    ✗ %s (not installed, should delete from config)", parser))
      end
    end
    print(string.format("    Total: %d", #removed))
    print ""
  end

  -- 4) Configured but not installed (only those that can be installed)
  local not_installed_installable = {}
  for _, parser in ipairs(not_installed) do
    if has_install_info[parser] then
      table.insert(not_installed_installable, parser)
    end
  end
  if #not_installed_installable > 0 then
    print "  [Configured But Not Installed — SHOULD INSTALL]"
    for _, parser in ipairs(not_installed_installable) do
      print(string.format("    ! %s", parser))
    end
    print(string.format("    Total: %d", #not_installed_installable))
    print ""
  end
  if #not_installed_trackers > 0 then
    print "  [Configured But Not Installable]"
    print "  (tracked in config but no parser source)"
    for _, parser in ipairs(not_installed_trackers) do
      print(string.format("    ~ %s", parser))
    end
    print ""
  end

  -- Summary with actionable lists
  divider()
  print(string.format("  Configured: %d   Upstream: %d   Installed: %d", #our_parsers, #upstream, #installed))
  print(
    string.format(
      "  OK: %d   New: %d   Removed: %d   Not installed: %d",
      #installed_configured,
      #new_upstream,
      #removed,
      #not_installed_installable
    )
  )
  divider()
  print()
  if #new_upstream > 0 then
    print(string.format("  Add to user.treesitter_parsers:  %s", table.concat(new_upstream, ", ")))
  end
  if #removed > 0 then
    print(string.format("  Delete from user.treesitter_parsers:  %s", table.concat(removed, ", ")))
  end
  if #not_installed_installable > 0 then
    print(string.format("  Install with :TSInstall:  %s", table.concat(not_installed_installable, ", ")))
  end
  if #new_upstream > 0 or #removed > 0 or #not_installed_installable > 0 then
    print()
  end
  divider()

  -- Determine exit code — fail on anything actionable
  local issues = #removed + #not_installed_installable + #new_upstream
  if issues > 0 then
    print(
      string.format(
        "  FAIL: %d issue(s) found (removed: %d, not installed: %d, new upstream: %d)",
        issues,
        #removed,
        #not_installed_installable,
        #new_upstream
      )
    )
    os.exit(1)
  end

  print "  PASS: All parsers are properly configured and installed."
  os.exit(0)
end

return M
