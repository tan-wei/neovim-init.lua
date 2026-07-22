local M = {}

local function regex(pattern)
  return {
    kind = "regex",
    value = pattern,
  }
end

-- Keep these patterns narrow and section-scoped.
-- Plain strings use simple substring matching; use regex(...) only when Vim regex is needed.
local ignored_message_patterns_by_section = {
  ["blink-cmp-git"] = {
    [["glab" not found, will use "curl" instead.]],
  },
  ["blink.cmp"] = {
    [[Some providers may show up as "disabled" but are enabled dynamically]],
  },
  copilot = {
    [[LSP authentication status: not authenticated]],
    [[Suggestions disabled in configuration]],
  },
  lazy = {
    regex [[^found existing packages at]],
  },
  mason = {
    [[Composer: not available]],
    [[PHP: not available]],
    [[javac: not available]],
    [[java: not available]],
    [[julia: not available]],
    [[pip: not available]],
  },
  overseer = {
    [[{cargo}: No Cargo.toml file found]],
    [[{cargo-make}: Command "cargo-make" not found]],
    [[{composer}: executable composer not found]],
    [[{deno}: executable deno not found]],
    [[{devenv}: Command "devenv" not found]],
    [[{mage}: Command "mage" not found]],
    [[{make}: No Makefile found]],
    [[{mise}: Command "mise" not found]],
    [[{mix}: No mix.exs file found]],
    [[{npm}: No package.json file found]],
    [[{rake}: Command "rake" not found]],
    [[{task}: Command "task" not found]],
    [[{tox}: No tox.ini file found]],
    [[{vscode}: No .vscode/tasks.json file found]],
  },
  snacks = {
    [[setup {disabled}]],
    [[None of the tools found: 'magick', 'convert']],
    [[`magick` is required to convert images.]],
    [[Tool not found: 'mmdc']],
    [[`mmdc` is required to render Mermaid diagrams]],
    [[your terminal does not support the kitty graphics protocol]],
    [[`vim.ui.input` is not set to `Snacks.input`]],
    [[`vim.ui.select` is not set to `Snacks.picker.select`]],
    [[is not ready]],
    [[Image rendering in docs with missing treesitter parsers won't work]],
    regex [[^Missing Treesitter languages:]],
  },
  ["vim.deprecated"] = {
    [[vim.F.if_nil is deprecated. Feature will be removed in Nvim 0.15]],
    [[vim.validate{<table>} is deprecated. Feature will be removed in Nvim 1.0]],
  },
  ["vim.health"] = {
    [[Build is outdated.]],
    [[Graphics protocol: not supported by this terminal.]],
  },
  ["vim.lsp"] = {
    [[Unknown filetype 'cxx']],
    [[Unknown filetype 'h']],
    [[Unknown filetype 'hpp']],
    [[Unknown filetype 'markdown.mdx']],
    [[Unknown filetype 'yaml.docker-compose']],
    [[Unknown filetype 'yaml.gitlab']],
    [[Unknown filetype 'yaml.helm-values']],
    regex [[^Log size:.*KB$]],
  },
  ["vim.provider"] = {
    [[Missing "neovim" npm]],
    [["Neovim::Ext" cpan module is not installed]],
    [[No usable perl executable found]],
    [[No Python executable found that can `import neovim`]],
    [[Could not load Python]],
    [[`neovim-ruby-host` not found.]],
  },
  ["vim.ui.img"] = {
    [[Graphics protocol: not supported by this terminal.]],
  },
  vimtex = {
    [[biber is not executable!]],
    [[Zathura requires xdotool for forward search!]],
  },
  ["vim.pack"] = {
    [[Lockfile is absent, plugin directory is present.]],
  },
  ["which-key"] = {
    [[|mini.icons| is not installed]],
  },
}

local compiled_ignored_message_patterns_by_section = {}
for section, patterns in pairs(ignored_message_patterns_by_section) do
  compiled_ignored_message_patterns_by_section[section] = {}
  for _, pattern in ipairs(patterns) do
    if type(pattern) == "string" then
      table.insert(compiled_ignored_message_patterns_by_section[section], {
        kind = "literal",
        value = pattern,
      })
    else
      table.insert(compiled_ignored_message_patterns_by_section[section], {
        kind = "regex",
        value = vim.regex(pattern.value),
      })
    end
  end
end

local function fail_check(message)
  vim.api.nvim_echo({ { message, "ErrorMsg" } }, true, {})
  vim.cmd "cquit 1"
end

local function health_buffer_lines()
  vim.cmd "silent checkhealth"

  local target
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bufnr) == "health://" then
      target = bufnr
      break
    end
  end

  if not target then
    fail_check "Health check failed: could not find health:// buffer"
    return nil
  end

  return vim.api.nvim_buf_get_lines(target, 0, -1, false)
end

local function parse_findings(lines)
  local findings = {}
  local section

  for _, line in ipairs(lines) do
    local next_section = line:match "^([%w%._%-]+):"
    if next_section then
      section = next_section
    else
      local message = line:match "^%s*%- .-WARNING%s+(.*)$"
      if message then
        table.insert(findings, {
          section = section or "<unknown>",
          severity = "warning",
          message = message,
        })
      else
        message = line:match "^%s*%- .-ERROR%s+(.*)$"
        if message then
          table.insert(findings, {
            section = section or "<unknown>",
            severity = "error",
            message = message,
          })
        end
      end
    end
  end

  return findings
end

local function is_ignored(finding)
  local patterns = compiled_ignored_message_patterns_by_section[finding.section]
  if not patterns then
    return false
  end

  for _, pattern in ipairs(patterns) do
    if pattern.kind == "literal" and string.find(finding.message, pattern.value, 1, true) then
      return true
    end

    if pattern.kind == "regex" and pattern.value:match_str(finding.message) then
      return true
    end
  end

  return false
end

local function sort_findings(findings)
  table.sort(findings, function(left, right)
    if left.section == right.section then
      if left.severity == right.severity then
        return left.message < right.message
      end

      return left.severity < right.severity
    end

    return left.section < right.section
  end)
end

local function summarize_by_section(findings)
  local counts = {}

  for _, finding in ipairs(findings) do
    counts[finding.section] = (counts[finding.section] or 0) + 1
  end

  local sections = vim.tbl_keys(counts)
  table.sort(sections)

  return sections, counts
end

function M.check()
  local lines = health_buffer_lines()
  if not lines then
    return
  end

  local findings = parse_findings(lines)
  local actionable = {}
  local ignored = {}

  for _, finding in ipairs(findings) do
    if is_ignored(finding) then
      ignored[#ignored + 1] = finding
    else
      actionable[#actionable + 1] = finding
    end
  end

  sort_findings(actionable)
  sort_findings(ignored)

  print(string.format("Health findings: total %d  ignored %d  actionable %d", #findings, #ignored, #actionable))

  if #ignored > 0 then
    local sections, counts = summarize_by_section(ignored)
    print "Ignored health findings by section:"
    for _, section in ipairs(sections) do
      print(string.format("~ %s: %d", section, counts[section]))
    end
  end

  if #actionable == 0 then
    print "Health check passed: no non-ignored WARNING/ERROR findings remained."
    return
  end

  print "Actionable health findings:"
  for _, finding in ipairs(actionable) do
    local marker = finding.severity == "error" and "×" or "!"
    print(string.format("%s [%s] %s", marker, finding.section, finding.message))
  end

  fail_check(string.format("Health check failed: %d actionable finding(s)", #actionable))
end

return M
