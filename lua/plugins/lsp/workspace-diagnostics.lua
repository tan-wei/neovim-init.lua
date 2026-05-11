local M = {
  "artemave/workspace-diagnostics.nvim",
  module = true,
}

M.opts = {
  workspace_files = function()
    local skip_extensions = {
      zst = true,
      gz = true,
      bz2 = true,
      xz = true,
      lzma = true,
      zip = true,
      ["7z"] = true,
      rar = true,
      tar = true,
    }

    local max_size = 1.5 * 1024 * 1024
    local max_files = 250
    local skip_path_fragments = {
      "/.git/",
      "/.cache/",
      "/build/",
      "/cmake-build/",
      "/node_modules/",
      "/vendor/",
      "/third_party/",
      "/third-party/",
      "/deps/",
      "/.deps/",
    }
    local snacks_ok, snacks = pcall(require, "snacks")
    if snacks_ok and snacks.config and snacks.config.get then
      local bigfile = snacks.config.get("bigfile", { size = max_size })
      if type(bigfile) == "table" and type(bigfile.size) == "number" and bigfile.size > 0 then
        max_size = bigfile.size
      end
    end

    local current = vim.api.nvim_buf_get_name(0)
    local start = current ~= "" and vim.fs.dirname(current) or vim.uv.cwd()
    local root = vim.fs.root(start, { ".git" })
    if not root then
      return {}
    end

    local supported_filetypes = {}
    for _, client in ipairs(vim.lsp.get_clients()) do
      for _, ft in ipairs(client.config.filetypes or {}) do
        supported_filetypes[ft] = true
      end
    end

    local function is_binary(path)
      local fd = vim.uv.fs_open(path, "r", 438)
      if not fd then
        return false
      end
      local chunk = vim.uv.fs_read(fd, 2048, 0)
      vim.uv.fs_close(fd)
      return type(chunk) == "string" and chunk:find("\0", 1, true) ~= nil
    end

    local files = vim.fn.systemlist({ "git", "-C", root, "ls-files" })
    if vim.v.shell_error ~= 0 then
      return {}
    end

    local candidates = vim.tbl_filter(function(path)
      if path == "" then
        return false
      end

      local fullpath = root .. "/" .. path
      local normalized = "/" .. path:gsub("\\", "/")
      for _, fragment in ipairs(skip_path_fragments) do
        if normalized:find(fragment, 1, true) then
          return false
        end
      end

      if vim.fn.filereadable(fullpath) ~= 1 then
        return false
      end

      local ext = vim.fn.fnamemodify(path, ":e"):lower()
      if skip_extensions[ext] then
        return false
      end

      local stat = vim.uv.fs_stat(fullpath)
      if stat and stat.type == "file" and stat.size and stat.size > max_size then
        return false
      end

      if is_binary(fullpath) then
        return false
      end

      local filetype = vim.filetype.match({ filename = fullpath })
      if not filetype then
        return false
      end

      if next(supported_filetypes) ~= nil and not supported_filetypes[filetype] then
        return false
      end

      return true
    end, files)

    if #candidates > max_files then
      table.sort(candidates, function(a, b)
        local a_path = root .. "/" .. a
        local b_path = root .. "/" .. b
        local a_stat = vim.uv.fs_stat(a_path)
        local b_stat = vim.uv.fs_stat(b_path)
        local a_size = (a_stat and a_stat.size) or math.huge
        local b_size = (b_stat and b_stat.size) or math.huge
        return a_size < b_size
      end)
      candidates = vim.list_slice(candidates, 1, max_files)
    end

    return vim.tbl_map(function(path)
      return root .. "/" .. path
    end, candidates)
  end,
}

return M
