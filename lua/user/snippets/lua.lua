local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

local function plugin_snippet(template, nodes)
  return sn(nil, fmt(template, nodes))
end

local function returned_module_name()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for line_index = #lines, 1, -1 do
    local module_name = lines[line_index]:match "^%s*return%s+([%a_][%w_]*)%s*$"
    if module_name ~= nil then
      return module_name
    end
  end

  return "M"
end

local function module_function_static()
  return sn(
    nil,
    fmt(
      [[
function {}.{}({})
  {}
end
      ]],
      {
        f(returned_module_name),
        i(1, "name"),
        i(2),
        i(0),
      }
    )
  )
end

local function module_function_method()
  return sn(
    nil,
    fmt(
      [[
function {}:{}({})
  {}
end
      ]],
      {
        f(returned_module_name),
        i(1, "name"),
        i(2),
        i(0),
      }
    )
  )
end

local function plugin_minimal()
  return plugin_snippet(
    [[
local M = {{
  "{}",
}}

return M
  ]],
    { i(1, "author/repo") }
  )
end

local function plugin_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2),
    }
  )
end

local function plugin_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2),
    }
  )
end

local function plugin_event()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  event = "{}",
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "VeryLazy"),
    }
  )
end

local function plugin_event_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  event = "{}",
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "VeryLazy"),
      i(3),
    }
  )
end

local function plugin_event_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  event = "{}",
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "VeryLazy"),
      i(3),
    }
  )
end

local function plugin_dependencies()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
    }
  )
end

local function plugin_dependencies_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3),
    }
  )
end

local function plugin_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3),
    }
  )
end

local function plugin_event_dependencies()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  event = "{}",
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "VeryLazy"),
    }
  )
end

local function plugin_event_dependencies_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  event = "{}",
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "VeryLazy"),
      i(4),
    }
  )
end

local function plugin_event_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  event = "{}",
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "VeryLazy"),
      i(4),
    }
  )
end

local function plugin_cmd()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  cmd = {{ "{}" }},
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "MyCommand"),
    }
  )
end

local function plugin_cmd_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  cmd = {{ "{}" }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "MyCommand"),
      i(3),
    }
  )
end

local function plugin_cmd_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  cmd = {{ "{}" }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "MyCommand"),
      i(3),
    }
  )
end

local function plugin_cmd_dependencies()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  cmd = {{ "{}" }},
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "MyCommand"),
    }
  )
end

local function plugin_cmd_dependencies_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  cmd = {{ "{}" }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "MyCommand"),
      i(4),
    }
  )
end

local function plugin_cmd_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  cmd = {{ "{}" }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "MyCommand"),
      i(4),
    }
  )
end

local function plugin_ft()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  ft = {{ "{}" }},
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "lua"),
    }
  )
end

local function plugin_ft_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  ft = {{ "{}" }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "lua"),
      i(3),
    }
  )
end

local function plugin_ft_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  ft = {{ "{}" }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "lua"),
      i(3),
    }
  )
end

local function plugin_ft_dependencies_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  ft = {{ "{}" }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "lua"),
      i(4),
    }
  )
end

local function plugin_ft_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  ft = {{ "{}" }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "lua"),
      i(4),
    }
  )
end

local function plugin_ft_cmd_dependencies_opts()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  ft = {{ "{}" }},
  cmd = {{ "{}" }},
}}

M.opts = {{
  {}
}}

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, "lua"),
      i(4, "MyCommand"),
      i(5),
    }
  )
end

local function plugin_enabled_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  enabled = {},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "true"),
      i(3),
    }
  )
end

local function plugin_event_enabled_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  event = "{}",
  enabled = {},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "VeryLazy"),
      i(3, "true"),
      i(4),
    }
  )
end

local function plugin_branch_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  branch = "{}",
  dependencies = {{
    "{}",
  }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "main"),
      i(3, "nvim-lua/plenary.nvim"),
      i(4),
    }
  )
end

local function plugin_build_init_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  build = function()
    {}
  end,
  lazy = false,
}}

M.init = function()
  {}
end

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "nvim-lua/plenary.nvim"),
      i(3, 'require("plugin").install()'),
      i(4),
      i(5),
    }
  )
end

local function plugin_version_build_event_dependencies_config()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  version = "{}",
  build = function()
    {}
  end,
  dependencies = {{
    "{}",
  }},
  event = {{ "{}" }},
}}

M.config = function()
  {}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "*"),
      i(3),
      i(4, "nvim-lua/plenary.nvim"),
      i(5, "InsertEnter"),
      i(6),
    }
  )
end

local function colorscheme_lazy_init()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "theme-name"),
    }
  )
end

local function colorscheme_name_lazy_init()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  name = "{}",
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "theme-name"),
      i(3, "theme-name"),
    }
  )
end

local function colorscheme_lazy_init_config_true()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "theme-name"),
    }
  )
end

local function colorscheme_lazy_init_config_fn()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("{}").setup {{}}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "theme-name"),
      i(3, "theme-name"),
    }
  )
end

local function colorscheme_dependencies_lazy_init()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "rktjmp/lush.nvim"),
      i(3, "theme-name"),
    }
  )
end

local function colorscheme_dependencies_lazy_init_config_true()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "rktjmp/lush.nvim"),
      i(3, "theme-name"),
    }
  )
end

local function colorscheme_dependencies_lazy_init_config_fn()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  dependencies = {{
    "{}",
  }},
  lazy = true,
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("{}").setup {{}}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "rktjmp/lush.nvim"),
      i(3, "theme-name"),
      i(4, "theme-name"),
    }
  )
end

local function colorscheme_build_lazy_init_config_fn()
  return plugin_snippet(
    [[
local M = {{
  "{}",
  lazy = true,
  build = "{}",
}}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {{}}
  table.insert(available_colorschemes, "{}")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("{}").setup {{}}
end

return M
  ]],
    {
      i(1, "author/repo"),
      i(2, "make"),
      i(3, "theme-name"),
      i(4, "theme-name"),
    }
  )
end

return {
  --- PLUGIN ---
  s(
    {
      trig = "plu",
      name = "Plugin",
      dscr = "Choice-based lazy.nvim plugin spec",
    },
    c(1, {
      plugin_minimal(),
      plugin_config(),
      plugin_opts(),
      plugin_event(),
      plugin_event_opts(),
      plugin_event_config(),
      plugin_dependencies(),
      plugin_dependencies_opts(),
      plugin_dependencies_config(),
      plugin_event_dependencies(),
      plugin_event_dependencies_opts(),
      plugin_event_dependencies_config(),
      plugin_cmd(),
      plugin_cmd_opts(),
      plugin_cmd_config(),
      plugin_cmd_dependencies(),
      plugin_cmd_dependencies_opts(),
      plugin_cmd_dependencies_config(),
      plugin_ft(),
      plugin_ft_opts(),
      plugin_ft_config(),
      plugin_ft_dependencies_opts(),
      plugin_ft_dependencies_config(),
      plugin_ft_cmd_dependencies_opts(),
      plugin_enabled_config(),
      plugin_event_enabled_config(),
      plugin_branch_dependencies_config(),
      plugin_build_init_config(),
      plugin_version_build_event_dependencies_config(),
    })
  ),

  s(
    {
      trig = "colo",
      name = "Colorscheme",
      dscr = "Choice-based colorscheme plugin spec",
    },
    c(1, {
      colorscheme_lazy_init(),
      colorscheme_name_lazy_init(),
      colorscheme_lazy_init_config_true(),
      colorscheme_lazy_init_config_fn(),
      colorscheme_dependencies_lazy_init(),
      colorscheme_dependencies_lazy_init_config_true(),
      colorscheme_dependencies_lazy_init_config_fn(),
      colorscheme_build_lazy_init_config_fn(),
    })
  ),

  s(
    {
      trig = "pluo",
      name = "Plugin Opts",
      dscr = "lazy.nvim plugin spec with event and M.opts",
    },
    fmt(
      [[
local M = {{
  "{}",
  event = "{}",
}}

M.opts = {{
  {}
}}

return M
  ]],
      {
        i(1, "author/repo"),
        i(2, "VeryLazy"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "pluc",
      name = "Plugin Config",
      dscr = "lazy.nvim plugin spec with event and M.config",
    },
    fmt(
      [[
local M = {{
  "{}",
  event = "{}",
}}

M.config = function()
  {}
end

return M
  ]],
      {
        i(1, "author/repo"),
        i(2, "VeryLazy"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "mfn",
      name = "Module Function",
      dscr = "Module function or method using the returned table name",
    },
    c(1, {
      module_function_static(),
      module_function_method(),
    })
  ),

  --- SNIPPET ---
  s(
    {
      trig = "sni",
      name = "Snippet",
    },
    fmt(
      [[
local luasnip = require "luasnip"
local s = luasnip.snippet
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

return {{
  {}
}}
  ]],
      i(1, "snippet")
    )
  ),
}
