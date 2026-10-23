local M = {}
local states = {}
local initialized = false

local template = [[json({
  "change_id" => stringify(change_id.shortest(8)),
  "bookmarks" => stringify(local_bookmarks.map(|bookmark| stringify(bookmark.name())).join(" ")),
  "description" => description.first_line(),
  "conflict" => conflict,
  "empty" => empty,
  "divergent" => divergent
})]]

function M.get()
  local state = states[vim.b.jj_status_root]
  return state and state.data or nil
end

function M.refresh()
  local name = vim.api.nvim_buf_get_name(0)
  local directory = vim.bo.buftype == "" and name ~= "" and not name:match "^%w+://" and vim.fs.dirname(name)
    or vim.fn.getcwd()
  local root = vim.fs.root(directory, function(marker)
    return marker == ".jj" or marker == ".git"
  end)
  if root and not vim.uv.fs_stat(vim.fs.joinpath(root, ".jj")) then
    root = nil
  end
  vim.b.jj_status_root = root
  if not root or vim.fn.executable "jj" ~= 1 then
    return
  end

  local state = states[root] or { data = { root = root }, updated = 0 }
  states[root] = state
  local now = vim.uv.now()
  if state.pending or now - state.updated < 1000 then
    return
  end
  state.pending = true
  state.updated = now

  vim.system({ "jj", "--no-pager", "--color=never", "log", "--no-graph", "-r", "@", "-T", template }, {
    cwd = root,
    text = true,
    timeout = 3000,
  }, function(result)
    vim.schedule(function()
      state.pending = false
      local ok, data = pcall(vim.json.decode, result.stdout or "")
      if result.code == 0 and ok and type(data) == "table" and type(data.change_id) == "string" then
        data.root = root
        state.data = data
      else
        state.data = { root = root, error = true }
      end
      vim.cmd.redrawstatus()
    end)
  end)
end

function M.setup()
  if initialized then
    return
  end
  initialized = true
  local group = vim.api.nvim_create_augroup("JujutsuStatus", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "TermLeave", "DirChanged", "CursorHold" }, {
    group = group,
    callback = M.refresh,
  })
  M.refresh()
end

return M
