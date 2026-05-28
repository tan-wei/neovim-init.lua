local M = {}

local function normalize_url(url)
  if type(url) ~= "string" or url == "" then
    return nil
  end

  if not url:match "^https?://" then
    return nil
  end

  return (url:gsub("%.git/*$", ""):gsub("/+$", ""))
end

local function comparison_key(url)
  local normalized = normalize_url(url)
  if not normalized then
    return nil
  end

  return normalized:lower()
end

local function plugin_urls()
  local urls = {}
  for _, plugin in pairs(require("lazy.core.config").plugins) do
    local url = normalize_url(plugin.url)
    local key = comparison_key(url)
    if key and not urls[key] then
      urls[key] = url
    end
  end

  local list = vim.tbl_values(urls)
  table.sort(list)
  return list
end

local function curl_args(url, output_path)
  return {
    "curl",
    "--silent",
    "--show-error",
    "--location",
    "--output",
    output_path,
    "--write-out",
    "%{http_code}\t%{url_effective}",
    "--retry",
    tostring(tonumber(vim.env.LINK_CHECK_RETRIES) or 2),
    "--connect-timeout",
    tostring(tonumber(vim.env.LINK_CHECK_CONNECT_TIMEOUT) or 10),
    "--max-time",
    tostring(tonumber(vim.env.LINK_CHECK_MAX_TIME) or 30),
    url,
  }
end

local function summarize_curl_failure(obj)
  local stderr = vim.trim(obj.stderr or "")
  if stderr == "" then
    return string.format("curl exited with code %d", obj.code)
  end

  return string.format("curl exited with code %d: %s", obj.code, stderr)
end

local function status_rank(status)
  if status == "error" then
    return 1
  end

  if status == "redirect" then
    return 2
  end

  return 3
end

local function format_result(result)
  if result.status == "ok" then
    return string.format("√ %s", result.url)
  end

  if result.status == "redirect" then
    return string.format("↪ %s -> %s", result.url, result.detail)
  end

  return string.format("× %s -> %s", result.url, result.detail)
end

local function fail_check(message)
  vim.api.nvim_echo({ { message, "ErrorMsg" } }, true, {})
  vim.cmd "cquit 1"
end

function M.check()
  local urls = plugin_urls()
  if #urls == 0 then
    fail_check "Plugin link check failed: no plugin URLs resolved from lazy.nvim"
    return
  end

  local max_jobs = math.max(1, tonumber(vim.env.LINK_CHECK_JOBS) or 16)
  local timeout_ms = tonumber(vim.env.LINK_CHECK_TIMEOUT_MS) or math.max(60000, #urls * 1000)

  local results = {}
  local next_index = 1
  local pending = 0
  local finished = false

  local function push_result(status, url, detail)
    results[#results + 1] = {
      status = status,
      url = url,
      detail = detail,
    }
  end

  local function maybe_finish()
    if next_index > #urls and pending == 0 then
      finished = true
    end
  end

  local spawn_next
  spawn_next = function()
    while pending < max_jobs and next_index <= #urls do
      local url = urls[next_index]
      next_index = next_index + 1
      pending = pending + 1

      local output_path = vim.fn.tempname()
      vim.system(curl_args(url, output_path), { text = true }, function(obj)
        vim.schedule(function()
          pending = pending - 1
          vim.fn.delete(output_path)

          if obj.code ~= 0 then
            push_result("error", url, summarize_curl_failure(obj))
          else
            local stdout = vim.trim(obj.stdout or "")
            local http_code, effective_url = stdout:match "^(%d+)\t(.*)$"
            if not http_code then
              push_result("error", url, "unexpected curl output: " .. stdout)
            else
              local code = tonumber(http_code)
              local expected = comparison_key(url)
              local actual = comparison_key(effective_url)

              if code >= 400 then
                push_result("error", url, string.format("HTTP %d", code))
              elseif actual and expected ~= actual then
                push_result("redirect", url, normalize_url(effective_url))
              else
                push_result("ok", url)
              end
            end
          end

          spawn_next()
          maybe_finish()
        end)
      end)
    end
  end

  spawn_next()

  local ok = vim.wait(timeout_ms, function()
    return finished
  end, 100)

  if not ok then
    fail_check(string.format("Plugin link check failed: timed out after %d ms", timeout_ms))
    return
  end

  table.sort(results, function(left, right)
    local left_rank = status_rank(left.status)
    local right_rank = status_rank(right.status)
    if left_rank ~= right_rank then
      return left_rank < right_rank
    end

    return left.url < right.url
  end)

  local ok_count = 0
  local redirect_count = 0
  local error_count = 0

  for _, result in ipairs(results) do
    print(format_result(result))

    if result.status == "ok" then
      ok_count = ok_count + 1
    elseif result.status == "redirect" then
      redirect_count = redirect_count + 1
    else
      error_count = error_count + 1
    end
  end

  print(
    string.format(
      "Plugin link check summary: √ %d  ↪ %d  × %d  (total %d)",
      ok_count,
      redirect_count,
      error_count,
      #results
    )
  )

  if redirect_count > 0 or error_count > 0 then
    local problems = {}

    if redirect_count > 0 then
      problems[#problems + 1] = string.format("%d redirect%s", redirect_count, redirect_count == 1 and "" or "s")
    end

    if error_count > 0 then
      problems[#problems + 1] = string.format("%d missing/error link%s", error_count, error_count == 1 and "" or "s")
    end

    fail_check("Plugin link check failed: " .. table.concat(problems, ", "))
    return
  end

  print(string.format("Plugin link check passed for %d plugin sources", #results))
end

return M
