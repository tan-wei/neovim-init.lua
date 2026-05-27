---@type LazyPluginSpec
local M = {
  "folke/which-key.nvim",
  lazy = false,
}

M.config = function()
  local wk = require "which-key"

  wk.setup {
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "<leader>", mode = { "n", "v" } },
      { "<localleader>", mode = { "n", "v" } },
    },
  }

  -- Shared retry budget for both the temporary bootstrap mapping below and
  -- the real trigger-priming pass further down.
  local startup_retry_delay = 50
  local startup_retry_attempts = 60

  -- Install a lightweight bootstrap trigger for leader/localleader while the
  -- real which-key triggers are still being primed. Keep it conservative:
  -- only show in the mode where the prefix was pressed, and never reopen when
  -- the popup is already visible.
  local seen_prefixes = {}
  for _, prefix in ipairs { vim.g.mapleader, vim.g.maplocalleader } do
    if prefix and prefix ~= "" and not seen_prefixes[prefix] then
      seen_prefixes[prefix] = true

      for _, mode in ipairs { "n", "x" } do
        vim.keymap.set(mode, prefix, function()
          local pressed_mode = vim.api.nvim_get_mode().mode

          local ok_view, wk_view = pcall(require, "which-key.view")
          if ok_view and wk_view.valid() then
            return
          end

          local function show_prefix(attempt)
            local ok_config, wk_config = pcall(require, "which-key.config")
            if not ok_config then
              return
            end

            if wk_config.loaded and wk_config.triggers and wk_config.triggers.modes then
              vim.schedule(function()
                if vim.api.nvim_get_mode().mode ~= pressed_mode then
                  return
                end

                local ok_current_view, current_view = pcall(require, "which-key.view")
                if ok_current_view and current_view.valid() then
                  return
                end

                require("which-key").show {
                  keys = prefix,
                  mode = pressed_mode,
                }
              end)
            elseif attempt < startup_retry_attempts then
              vim.defer_fn(function()
                show_prefix(attempt + 1)
              end, startup_retry_delay)
            end
          end

          show_prefix(0)
        end, {
          desc = "which-key-trigger bootstrap prefix",
          nowait = true,
        })
      end
    end
  end

  -- Prime the real which-key trigger state after startup and session restore.
  -- The bootstrap prefix mapping above keeps `<leader>` / `<localleader>` from
  -- going dead during the startup window; this pass is what lets the normal
  -- which-key-managed trigger mappings take over afterwards.
  --
  -- Why this exists:
  -- `lazy = false` only guarantees the plugin spec loads eagerly. which-key v3
  -- still finalizes parts of its trigger/buffer state around VimEnter and later
  -- event updates, so the first `<leader>` / `<localleader>` press can
  -- occasionally miss the popup until another interaction forces a rescan.
  --
  -- Related upstream discussion:
  -- https://github.com/folke/which-key.nvim/issues/787
  -- https://github.com/folke/which-key.nvim/issues/1029
  -- https://github.com/folke/which-key.nvim/issues/476
  -- https://github.com/folke/which-key.nvim/pull/942
  --
  -- This local workaround retries a small current-buffer refresh until
  -- which-key finishes its own deferred startup. A single `vim.schedule()` is
  -- not always enough here, because upstream also schedules its real config
  -- load on VimEnter; if we run first, internal fields such as
  -- `which-key.config.triggers.modes` may still be nil. We also rerun the same
  -- priming step after `SessionLoadPost`, since restoring a session can change
  -- the current buffer/window layout after the initial VimEnter pass.
  local function prime_current_buffer_triggers()
    local attempts = 0

    local function refresh_triggers()
      local ok_config, wk_config = pcall(require, "which-key.config")
      local ok_buf, wk_buf = pcall(require, "which-key.buf")
      local ok_triggers, wk_triggers = pcall(require, "which-key.triggers")
      if not (ok_config and ok_buf and ok_triggers) then
        return
      end

      if not (wk_config.loaded and wk_config.triggers and wk_config.triggers.modes) then
        attempts = attempts + 1
        if attempts < startup_retry_attempts then
          vim.defer_fn(refresh_triggers, startup_retry_delay)
        end
        return
      end

      for _, mode in ipairs { "n", "x" } do
        local ok_mode, wk_mode = pcall(wk_buf.get, { buf = 0, mode = mode })
        if ok_mode and wk_mode then
          pcall(wk_triggers.update, wk_mode)
        end
      end
    end

    vim.schedule(refresh_triggers)
  end

  vim.api.nvim_create_autocmd({ "VimEnter", "SessionLoadPost" }, {
    callback = function()
      prime_current_buffer_triggers()
    end,
  })

  wk.add(require("user.keymap.registry").which_key_items())
end

-- M.config = function()
--   local which_key = require "which-key"

--   which_key.register({
--     b = {
--       name = "Buffers",
--       W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
--       -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
--     },
--     C = {
--       name = "Commet Box",
--       -- TODO
--     },

--     l = {
--       name = "LSP",
--       c = { "<cmd>lua require('treesitter-context').go_to_context()<cr>", "Jump to context" },
--       w = {
--         "<cmd>Telescope diagnostics<cr>",
--         "Workspace Diagnostics",
--       },
--     },
--     S = {},
--     s = {
--       name = "Search",
--       -- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--       -- c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
--       -- h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
--       -- M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--       -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--       -- R = { "<cmd>Telescope registers<cr>", "Registers" },
--       -- k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--       -- C = { "<cmd>Telescope commands<cr>", "Commands" },
--     },
--     T = {
--       name = "Terminal",
--       n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
--       u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
--       t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
--       p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
--     },

return M
