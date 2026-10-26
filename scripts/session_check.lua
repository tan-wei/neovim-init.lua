local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local script = root .. "/scripts/session_check.lua"
local case = vim.env.NVIM_SESSION_CHECK_CASE
local case_names = {
  "layout",
  "startup",
  "filters",
  "directory",
  "git",
  "scope",
  "overseer",
  "hooks",
  "errors",
  "commands",
  "terminal",
  "tree",
  "shutdown",
}

local function run_worker(name, directory, extra_env)
  local env = { NVIM_SESSION_CHECK_CASE = name, NVIM_SESSION_CHECK_DIR = directory }
  for key, value in pairs(extra_env or {}) do
    env[key] = value
  end
  return vim
    .system({ vim.v.progpath, "--headless", "-u", "NONE", "-i", "NONE", "-l", script }, {
      text = true,
      env = env,
    })
    :wait(30000)
end

if not case then
  local sandbox = vim.fn.tempname()
  local failures = {}
  for _, name in ipairs(case_names) do
    local result = run_worker(name, sandbox .. "/" .. name)
    if result.code == 0 then
      print("PASS: " .. name)
    else
      failures[#failures + 1] = name
      vim.api.nvim_err_writeln("FAIL: " .. name .. "\n" .. result.stdout .. result.stderr)
    end
  end
  vim.fn.delete(sandbox, "rf")
  if #failures > 0 then
    vim.api.nvim_err_writeln("Session checks failed: " .. table.concat(failures, ", "))
    vim.cmd "cquit 1"
  end
  print(string.format("Session checks passed: %d isolated suites", #case_names))
  vim.cmd "qa!"
end

local plugin_root = vim.fn.stdpath "data" .. "/lazy/"
local test_dir = assert(vim.env.NVIM_SESSION_CHECK_DIR, "worker sandbox missing")
local stdpath = vim.fn.stdpath

vim.fn.mkdir(test_dir .. "/data", "p")
vim.fn.stdpath = function(kind)
  if kind == "data" or kind == "state" or kind == "cache" or kind == "config" then
    vim.fn.mkdir(test_dir .. "/" .. kind, "p")
    return test_dir .. "/" .. kind
  end
  return stdpath(kind)
end
vim.env.AUTOSESSION_UNIT_TESTING = "1"
vim.env.NVIM = nil

for _, plugin in ipairs { "nvim-tree.lua", "nvim-web-devicons", "nvim-tree-preview.lua", "plenary.nvim", "auto-session" } do
  vim.opt.rtp:append(plugin_root .. plugin)
end
vim.opt.rtp:append(root)
vim.opt.sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions"

local loaded = {}
local calls = {}
local function record(name, value)
  calls[#calls + 1] = { name = name, value = value }
end

local function count(name)
  return #vim.tbl_filter(function(call)
    return call.name == name
  end, calls)
end

package.loaded["util.package"] = {
  is_loaded = function(name)
    return loaded[name] == true
  end,
}
package.loaded["treesitter-context"] = {
  enable = function()
    record "context-enable"
  end,
  disable = function()
    record "context-disable"
  end,
}
package.loaded["lualine"] = {
  refresh = function()
    record "statusline"
  end,
}
package.loaded["colorful-winsep.view"] = {
  render = function()
    record "separators"
  end,
}
vim.api.nvim_create_user_command("Winsep", function(opts)
  record("winsep", opts.args)
end, { nargs = 1 })

local function fixture(name, lines)
  local path = test_dir .. "/" .. name
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile(lines or { "first", "second", "third", "fourth" }, path)
  return path
end

local function edit(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function setup_session(overrides)
  dofile(root .. "/lua/plugins/filesystem/nvim-tree.lua").config()
  local session = require "auto-session"
  local setup = session.setup
  local options
  session.setup = function(opts)
    opts.git_use_branch_name = false
    opts.cwd_change_handling = false
    opts.auto_save = false
    opts.suppress_dirs = nil
    opts.suppressed_dirs = {}
    opts.lsp_stop_on_restore = false
    for key, value in pairs(overrides or {}) do
      opts[key] = value
    end
    options = opts
    return setup(opts)
  end
  dofile(root .. "/lua/plugins/project/auto-session.lua").config()
  session.setup = setup
  return session, options, require("nvim-tree.api").tree
end

local function saved_path(name)
  return require("auto-session").get_root_dir() .. require("auto-session.lib").escape_session_name(name) .. ".vim"
end

local function save(session, name)
  assert(session.save_session(name, { show_message = false }), "save failed: " .. tostring(name))
end

local function settle()
  vim.wait(100, function()
    return false
  end)
end

local suites = {}

suites.layout = function()
  local session = setup_session()
  local first = fixture "project/first.txt"
  local second = fixture "project/second.txt"
  edit(first)
  local pinned = vim.api.nvim_get_current_buf()
  vim.b[pinned].ignore_early_retirement = true
  vim.wo.number = true
  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  vim.cmd("vsplit " .. vim.fn.fnameescape(second))
  vim.wo.number = false
  vim.api.nvim_win_set_cursor(0, { 2, 0 })
  local focused = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_list_wins()
  save(session, "layout with spaces")
  assert(vim.deep_equal(windows, vim.api.nvim_list_wins()), "save changed windows")
  assert(vim.api.nvim_get_current_win() == focused, "save changed focus")
  assert(count "context-disable" == 1 and count "context-enable" == 1, "save did not bracket context rendering")
  assert(session.restore_session("layout with spaces", { show_message = false }))
  local states = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    states[vim.api.nvim_buf_get_name(buf)] =
      { vim.api.nvim_win_get_cursor(win)[1], vim.wo[win].number, vim.b[buf].ignore_early_retirement == true }
  end
  assert(vim.fn.winlayout()[1] == "row", "split orientation changed")
  assert(vim.deep_equal(states[first], { 3, true, true }), "pinned buffer or local state was lost")
  assert(vim.deep_equal(states[second], { 2, false, false }), "ordinary editor state was lost")
  assert(vim.o.titlestring:find("layout with spaces", 1, true), "title did not follow named session")
  assert(vim.api.nvim_buf_get_name(0) == second, "active editor was not restored")
end

suites.startup = function()
  local session, _, tree = setup_session()
  local path = fixture "startup/file.txt"
  edit(path)
  save(session, "unrelated-session")
  vim.cmd "enew"
  vim.v.this_session = ""
  assert(not session.start(), "startup restored an unrelated last session")
  assert(tree.is_visible(), "missing cwd session did not trigger default tree opening")
  tree.close_in_all_tabs()
  edit(path)
  save(session)
  vim.cmd "enew"
  assert(session.start(), "existing cwd session was not automatically restored")
  settle()
  assert(vim.api.nvim_buf_get_name(0) == path, "startup restored the wrong file")
  assert(not tree.is_visible(), "startup forced open a tree saved closed")
  tree.open()
  save(session)
  tree.close_in_all_tabs()
  assert(session.start(), "open-tree startup restore failed")
  vim.wait(100, function()
    return false
  end)
  assert(tree.is_visible(), "startup failed to restore open tree")
end

suites.filters = function()
  local session = setup_session { auto_save = true }
  local config = require "auto-session.config"
  edit(fixture "filters/file.txt")
  assert(not session.auto_save_session(), "auto_create=false created a session")
  assert(not session.session_exists_for_cwd(), "unexpected session file")
  save(session)
  assert(session.auto_save_session(), "existing session was not autosaved")
  config.auto_save = false
  assert(not session.auto_save_session(), "auto_save=false was ignored")
  config.auto_save = true
  config.enabled = false
  assert(not session.auto_save_session(), "enabled=false was ignored")
  config.enabled = true
  config.suppressed_dirs = { vim.fn.getcwd() }
  assert(not session.auto_save_session(), "suppressed directory was saved")
  assert(not session.auto_restore_session(nil, true), "suppressed directory was restored")
  config.suppressed_dirs = {}
  config.auto_restore = false
  assert(not session.auto_restore_session(nil, true), "auto_restore=false was ignored")
  config.auto_restore = true
  for _, filetype in ipairs(config.bypass_save_filetypes) do
    vim.bo.filetype = filetype
    assert(not session.auto_save_session(), "bypass ignored: " .. filetype)
  end
  vim.bo.filetype = "text"
  local real_win = vim.api.nvim_get_current_win()
  vim.cmd "vnew"
  local unsupported = vim.api.nvim_get_current_win()
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "session-check-panel"
  vim.api.nvim_set_current_win(real_win)
  assert(session.auto_save_session(), "mixed filetypes incorrectly bypassed autosave")
  assert(not vim.api.nvim_win_is_valid(unsupported), "unsupported window was not cleaned up")
  assert(session.restore_session_file(vim.v.this_session, { show_message = false }))
  assert(not session.manually_named_session, "cwd session was mistaken for a named session")
end

suites.directory = function()
  local session = setup_session { cwd_change_handling = true, auto_save = true }
  local first = fixture "first-project/file.txt"
  local second = fixture "second-project/file.txt"
  local first_dir = vim.fn.fnamemodify(first, ":h")
  local second_dir = vim.fn.fnamemodify(second, ":h")
  vim.cmd("noautocmd cd " .. vim.fn.fnameescape(second_dir))
  edit(second)
  save(session)
  vim.cmd("noautocmd cd " .. vim.fn.fnameescape(first_dir))
  edit(first)
  save(session)
  vim.lsp.get_clients = function()
    return { {
      stop = function()
        record "lsp-stop"
      end,
    } }
  end
  vim.cmd("cd " .. vim.fn.fnameescape(second_dir))
  assert(count "lsp-stop" == 1, "directory change did not stop LSP clients")
  assert(vim.api.nvim_buf_get_name(0) == first, "active buffers were unexpectedly replaced")
  assert(vim.v.this_session == "", "directory change kept the old session association")
  vim.cmd "silent! %bwipeout!"
  vim.cmd("noautocmd cd " .. vim.fn.fnameescape(first_dir))
  vim.cmd("cd " .. vim.fn.fnameescape(second_dir))
  vim.wait(1200, function()
    return false
  end)
  assert(vim.api.nvim_buf_get_name(0) == second, "clean directory switch failed to restore target session")
  assert(count "winsep" >= 3, "directory hooks did not disable and re-enable separators")
  assert(count "statusline" > 0, "directory restore did not refresh statusline")
end

suites.git = function()
  local session = setup_session { git_use_branch_name = true }
  local path = fixture "git-project/file.txt"
  local directory = vim.fn.fnamemodify(path, ":h")
  local function git(...)
    local command = { "git", "-C", directory }
    vim.list_extend(command, { ... })
    local result = vim
      .system(command, {
        text = true,
        stdin = "",
        env = {
          GIT_AUTHOR_NAME = "Session Check",
          GIT_AUTHOR_EMAIL = "session-check@example.invalid",
          GIT_COMMITTER_NAME = "Session Check",
          GIT_COMMITTER_EMAIL = "session-check@example.invalid",
        },
      })
      :wait()
    assert(result.code == 0, result.stderr)
    return vim.trim(result.stdout)
  end
  git("init", "--initial-branch=session-check-main")
  local empty_tree = git "mktree"
  local commit = git("-c", "commit.gpgsign=false", "commit-tree", empty_tree, "-m", "session fixture")
  git("update-ref", "refs/heads/session-check-main", commit)
  git("update-ref", "refs/heads/session-check-other", commit)
  vim.cmd("cd " .. vim.fn.fnameescape(directory))
  edit(path)
  save(session)
  local main = vim.v.this_session
  local lib = require "auto-session.lib"
  assert(
    lib.escaped_session_path_to_session_name(main):find("session-check-main", 1, true),
    "branch name missing from session path"
  )
  git("symbolic-ref", "HEAD", "refs/heads/session-check-other")
  save(session)
  local other = vim.v.this_session
  assert(
    main ~= other and lib.escaped_session_path_to_session_name(other):find("session-check-other", 1, true),
    "branch sessions collided"
  )
  assert(vim.fn.filereadable(main) == 1 and vim.fn.filereadable(other) == 1, "branch session was overwritten")
  git("symbolic-ref", "HEAD", "refs/heads/session-check-main")
  assert(session.auto_restore_session(), "branch-specific session failed to restore")
  assert(vim.v.this_session == main, "wrong branch session was restored")
  save(session, "named-session")
  require("auto-session.config").auto_save = true
  assert(session.auto_save_session(), "named session did not autosave")
  assert(vim.v.this_session == saved_path "named-session", "autosave changed the manual session name")
end

suites.scope = function()
  vim.opt.rtp:append(plugin_root .. "scope.nvim")
  dofile(root .. "/lua/plugins/general/scope.lua").config()
  local session = setup_session()
  local first = fixture "scope/first.txt"
  local second = fixture "scope/second.txt"
  edit(first)
  vim.cmd("tabnew " .. vim.fn.fnameescape(second))
  save(session, "scope-state")
  local saved = vim.json.decode(vim.g.ScopeState)
  assert(#saved.cache == 2, "Scope did not save both tabs")
  require("scope.core").cache = {}
  assert(session.restore_session("scope-state", { show_message = false }))
  assert(#vim.api.nvim_list_tabpages() == 2, "tab count was not restored")
  assert(
    vim.deep_equal(vim.json.decode(require("scope.session").serialize_state()), saved),
    "Scope buffer membership changed"
  )
end

suites.overseer = function()
  local session = setup_session()
  edit(fixture "tasks/file.txt")
  local payload = { name = "task's name", cmd = { "printf", "a/b", "quoted 'argument'" } }
  package.loaded["overseer.task_list"] = {
    list_tasks = function(opts)
      assert(opts.include_ephemeral == false and opts.unique == false)
      return {
        {
          serialize = function()
            return payload
          end,
        },
        {
          serialize = function()
            error "unserializable task"
          end,
        },
        {
          serialize = function()
            return nil
          end,
        },
      }
    end,
  }
  package.loaded.overseer = {
    list_tasks = function(opts)
      assert(opts.include_ephemeral == true and opts.unique == false)
      return {
        {
          dispose = function(_, force)
            assert(force)
            record "task-dispose"
          end,
        },
      }
    end,
    new_task = function(serialized)
      assert(vim.deep_equal(serialized, payload), "task serialization did not round trip")
      return {
        start = function()
          record "task-start"
        end,
      }
    end,
  }
  vim.g.restore_overseer_tasks = false
  save(session, "tasks-disabled")
  assert(
    vim.fn.filereadable((saved_path("tasks-disabled"):gsub("%.vim$", "x.vim"))) == 0,
    "disabled tasks wrote restore commands"
  )
  vim.g.restore_overseer_tasks = true
  save(session, "tasks-enabled")
  assert(session.restore_session("tasks-enabled", { show_message = false }))
  assert(count "task-dispose" == 1 and count "task-start" == 1, "tasks were not disposed then restored")
  vim.g.restore_overseer_tasks = false
  assert(session.restore_session("tasks-enabled", { show_message = false }))
  assert(count "task-start" == 1, "restore-time project opt-out was ignored")
  vim.g.restore_overseer_tasks = true
  package.loaded["overseer.task_list"].list_tasks = function()
    return {}
  end
  save(session, "tasks-enabled")
  assert(
    vim.fn.filereadable((saved_path("tasks-enabled"):gsub("%.vim$", "x.vim"))) == 0,
    "stale task restore commands were retained"
  )
end

suites.hooks = function()
  local session = setup_session()
  edit(fixture "hooks/file.txt")
  loaded["outline.nvim"] = true
  vim.api.nvim_create_user_command("OutlineClose", function()
    record "outline-close"
  end, {})
  vim.api.nvim_create_user_command("ConfigLocalSource", function()
    record "project-source"
  end, {})
  local dropbar = { _ = {}, enabled = true }
  package.loaded["lazy.core.config"] = { plugins = { ["dropbar.nvim"] = dropbar } }
  package.loaded.lazy = {
    load = function(opts)
      assert(opts.plugins[1] == "dropbar.nvim")
      dropbar._.loaded = true
      record "dropbar-load"
    end,
  }
  loaded["cmake-tools.nvim"] = true
  package.loaded["util.cmake_project"] = {
    select_root = function(path)
      record("cmake-root", path)
    end,
  }
  save(session, "hooks")
  assert(count "outline-close" == 1, "Outline was not closed before save")
  assert(session.restore_session("hooks", { show_message = false }))
  assert(count "project-source" == 2, "project config was not sourced before and after restore")
  assert(count "dropbar-load" == 1 and dropbar._.loaded, "dropbar was not loaded before restore")
  assert(count "cmake-root" == 1 and count "statusline" == 1, "CMake integration was not refreshed")
  assert(session.restore_session("hooks", { show_message = false }))
  assert(count "dropbar-load" == 1, "already-loaded dropbar was loaded twice")
  vim.api.nvim_del_user_command "ConfigLocalSource"
  package.loaded["config-local"] = {
    source = function()
      record "project-fallback"
    end,
  }
  assert(session.restore_session("hooks", { show_message = false }))
  assert(count "project-fallback" == 2, "project config fallback was not sourced")
end

suites.errors = function()
  local session, _, tree = setup_session { auto_save = true }
  edit(fixture "errors/file.txt")
  local windows = vim.api.nvim_list_wins()
  assert(not session.restore_session("missing", { show_message = false }))
  assert(vim.deep_equal(windows, vim.api.nvim_list_wins()), "missing session changed windows")
  local broken = saved_path "broken"
  fixture(
    "data/sessions/broken.vim",
    { "let v:this_session = expand('<sfile>:p')", "throw 'session-check intentional restore failure'" }
  )
  local notifications = {}
  vim.notify = function(message)
    notifications[#notifications + 1] = tostring(message)
  end
  assert(not session.restore_session_file(broken, { show_message = false }), "broken session was accepted")
  assert(require("auto-session.config").auto_save == false, "failed restore did not disable autosave")
  assert(not session.restore_in_progress, "restore guard was not cleared after failure")
  vim.v.this_session = ""
  session.run_cmds("no_restore", true)
  assert(not tree.is_visible(), "failed restore triggered startup fallback")
  assert(#notifications > 0, "restore error was not reported")
end

suites.commands = function()
  local session = setup_session()
  edit(fixture "commands/file.txt")
  vim.cmd "AutoSession save command-session"
  assert(vim.fn.filereadable(saved_path "command-session") == 1, "save command failed")
  vim.cmd "enew"
  vim.cmd "AutoSession restore command-session"
  assert(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t") == "file.txt", "restore command failed")
  vim.cmd "AutoSession delete command-session"
  assert(vim.fn.filereadable(saved_path "command-session") == 0, "delete command failed")
  local before = require("auto-session.config").auto_save
  vim.cmd "AutoSession toggle"
  assert(require("auto-session.config").auto_save ~= before, "toggle command failed")
  assert(session.get_root_dir():find(test_dir, 1, true), "session storage escaped the sandbox")
end

suites.terminal = function()
  local session = setup_session { auto_save = true }
  local path = fixture "terminal/file.txt"
  edit(path)
  vim.cmd "split"
  vim.cmd "enew"
  local job = vim.fn.termopen { vim.v.progpath, "--headless", "-u", "NONE", "-i", "NONE" }
  assert(job > 0, "terminal job did not start")
  save(session, "terminal-state")
  assert(session.auto_save_session(), "terminal layout did not autosave")
  assert(session.restore_session("terminal-state", { show_message = false }))
  settle()
  local terminals = 0
  local files = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      terminals = terminals + 1
      assert(vim.b[buf].terminal_job_id, "terminal job was not recreated")
      vim.fn.jobstop(vim.b[buf].terminal_job_id)
    elseif vim.api.nvim_buf_get_name(buf) == path then
      files = files + 1
    end
  end
  assert(terminals == 1 and files == 1, "terminal split layout was not restored")
end

suites.tree = function()
  local session, _, tree = setup_session()
  local focused = vim.api.nvim_get_current_win()
  assert(not session.start(), "isolated startup must not restore a session")
  assert(tree.is_visible(), "no-session startup must open the tree")
  assert(vim.api.nvim_get_current_win() == focused, "default opening must preserve focus")
  tree.close_in_all_tabs()
  session.run_cmds("no_restore", false)
  assert(not tree.is_visible(), "non-startup no_restore must not force the tree open")
  edit(fixture "tree/first.txt")
  tree.open { focus = false }
  local first_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd("tabnew " .. vim.fn.fnameescape(fixture "tree/second.txt"))
  assert(not tree.is_visible(), "new tabs must not force the tree open")
  tree.open { focus = false }
  local second_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd("tabnew " .. vim.fn.fnameescape(fixture "tree/third.txt"))
  local before = vim.api.nvim_list_wins()
  focused = vim.api.nvim_get_current_win()
  assert(session.save_session("tree-open", { show_message = false }))
  assert(vim.deep_equal(before, vim.api.nvim_list_wins()), "saving must not replace or close windows")
  assert(vim.api.nvim_get_current_win() == focused, "saving must preserve focus")
  assert(tree.winid { tabpage = first_tab }, "saving must preserve first tab's tree")
  assert(tree.winid { tabpage = second_tab }, "saving must preserve second tab's tree")
  settle()

  tree.close_in_all_tabs()
  assert(session.save_session("tree-closed", { show_message = false }))
  settle()

  local function restore(name, expected)
    assert(session.restore_session(name, { show_message = false }), "restore failed: " .. name)
    settle()
    local visible = {}
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      visible[#visible + 1] = tree.winid { tabpage = tab } ~= nil
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match "NvimTree_" then
          assert(vim.bo[buf].filetype == "NvimTree", "blank tree placeholder after " .. name)
          assert(vim.api.nvim_buf_line_count(buf) > 1, "tree was not rendered after " .. name)
        end
      end
    end
    assert(vim.deep_equal(visible, expected), name .. ": wrong per-tab tree state: " .. vim.inspect(visible))
  end

  restore("tree-open", { true, true, false })
  restore("tree-closed", { false, false, false })
  restore("tree-open", { true, true, false })
  for name, expected in pairs { ["tree-open"] = { true, true, false }, ["tree-closed"] = { false, false, false } } do
    local result = run_worker("reopen", test_dir, {
      NVIM_SESSION_CHECK_SOURCE = saved_path(name),
      NVIM_SESSION_CHECK_EXPECTED = vim.json.encode(expected),
    })
    assert(result.code == 0, "fresh-process restore failed: " .. name .. "\n" .. vim.inspect(result))
  end

  tree.close_in_all_tabs()
  session.run_cmds("no_restore", true)
  assert(not tree.is_visible(), "startup fallback must not override a restored session")
  vim.v.this_session = ""
  session.run_cmds "pre_restore"
  session.run_cmds("no_restore", true)
  assert(not tree.is_visible(), "failed restore must not trigger default opening")
end

suites.reopen = function()
  local session, _, tree = setup_session()
  assert(session.restore_session_file(assert(vim.env.NVIM_SESSION_CHECK_SOURCE), { show_message = false }))
  settle()
  local visible = {}
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    visible[#visible + 1] = tree.winid { tabpage = tab } ~= nil
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if tree.is_tree_buf(buf) then
        assert(
          vim.bo[buf].filetype == "NvimTree" and vim.api.nvim_buf_line_count(buf) > 1,
          "tree placeholder was not rebuilt"
        )
      end
    end
  end
  assert(vim.deep_equal(visible, vim.json.decode(assert(vim.env.NVIM_SESSION_CHECK_EXPECTED))), vim.inspect(visible))
end

suites.quit = function()
  local session, _, tree = setup_session { auto_save = true }
  local first = fixture "project/first.txt"
  edit(first)
  local focused = vim.api.nvim_get_current_win()
  tree.open()
  vim.api.nvim_set_current_win(focused)
  if vim.env.NVIM_SESSION_CHECK_MULTITAB then
    vim.cmd("tabnew " .. vim.fn.fnameescape(fixture "project/second.txt"))
    focused = vim.api.nvim_get_current_win()
    tree.open()
    vim.api.nvim_set_current_win(focused)
  end
  if vim.env.NVIM_SESSION_CHECK_SPLIT then
    vim.cmd("vsplit " .. vim.fn.fnameescape(fixture "project/second.txt"))
  end
  save(session, "exit-state")
  settle()
  assert(tree.is_visible(), "tree closed before quit")
  vim.api.nvim_win_set_cursor(0, { 3, 0 })
  if vim.env.NVIM_SESSION_CHECK_TREE_FOCUS then
    tree.focus()
  end
  if vim.env.NVIM_SESSION_CHECK_QUIT == "BdeleteOrClose" then
    vim.opt.rtp:append(plugin_root .. "snacks.nvim")
    package.loaded.snacks = { bufdelete = require "snacks.bufdelete" }
  end
  vim.cmd(assert(vim.env.NVIM_SESSION_CHECK_QUIT))
  error "quit command returned without exiting"
end

suites.shutdown = function()
  local session = setup_session()
  for _, action in ipairs {
    { name = "quit", command = "q" },
    { name = "quit-all", command = "qa" },
    { name = "write-quit", command = "wq" },
    { name = "tree-focused", command = "qa", tree_focus = "1" },
    { name = "multi-tab", command = "q", multi_tab = "1" },
    { name = "split-quit-all", command = "qa", split = "1" },
    { name = "delete-last-buffer", command = "BdeleteOrClose", empty = true },
  } do
    local directory = test_dir .. "/" .. action.name
    local result = run_worker("quit", directory, {
      NVIM_SESSION_CHECK_QUIT = action.command,
      NVIM_SESSION_CHECK_MULTITAB = action.multi_tab,
      NVIM_SESSION_CHECK_TREE_FOCUS = action.tree_focus,
      NVIM_SESSION_CHECK_SPLIT = action.split,
    })
    assert(result.code == 0, "quit failed: " .. action.name .. "\n" .. vim.inspect(result))
    local source = directory
      .. "/data/sessions/"
      .. require("auto-session.lib").escape_session_name "exit-state"
      .. ".vim"
    if action.empty then
      assert(vim.fn.filereadable(source) == 0, "last-buffer deletion retained an empty session")
    else
      assert(session.restore_session_file(source, { show_message = false }))
      settle()
      assert(require("nvim-tree.api").tree.is_visible(), "tree did not restore after " .. action.name)
      assert(#vim.api.nvim_list_tabpages() == (action.multi_tab and 2 or 1), "quit lost tabs: " .. action.name)
      local expected_file = (action.multi_tab or action.split) and "second.txt" or "first.txt"
      local restored_cursor
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
        if vim.fn.fnamemodify(path, ":t") == expected_file then
          restored_cursor = vim.api.nvim_win_get_cursor(win)[1]
        end
      end
      assert(restored_cursor == 3, "exit did not autosave changes after manual save: " .. action.name)
    end
  end
end

local ok, err = xpcall(assert(suites[case], "unknown suite: " .. case), debug.traceback)
local config = package.loaded["auto-session.config"]
if config then
  config.enabled = false
end
vim.fn.stdpath = stdpath
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd "cquit 1"
end
vim.cmd "qa!"
