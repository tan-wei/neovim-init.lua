-- Load user config (must be first, before plugins read vim.g values)
local config = require "user.config"
vim.g.completion_engine = config.completion_engine

require "user.options"
require "user.lazy"
require("user.keymaps").setup()
require "user.autocommands"
