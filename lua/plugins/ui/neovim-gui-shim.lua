local M = {
  "equalsraf/neovim-gui-shim",
  cond = require("util.client").is_gui_client(),
}

return M
