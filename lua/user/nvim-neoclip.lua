local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
  return
end

neoclip.setup {
  history = 1000,
  enable_persistent_history = false,
  length_limit = 1048576,
  continuous_sync = false,
  filter = nil,
  preview = true,
  prompt = nil,
  default_register = '"',
  default_register_macros = "q",
  enable_macro_history = true,
  content_spec_column = false,
  disable_keycodes_parsing = false,
  on_select = {
    move_to_front = false,
    close_telescope = true,
  },
  on_paste = {
    set_reg = false,
    move_to_front = false,
    close_telescope = true,
  },
  on_replay = {
    set_reg = false,
    move_to_front = false,
    close_telescope = true,
  },
  on_custom_action = {
    close_telescope = true,
  },
  keys = {
    telescope = {
      i = {
        select = "<cr>",
        paste = "<c-p>",
        paste_behind = "<c-k>",
        replay = "<c-q>", -- replay a macro
        delete = "<c-d>", -- delete an entry
        edit = "<c-e>", -- edit an entry
        custom = {},
      },
      n = {
        select = "<cr>",
        paste = "p",
        --- It is possible to map to more than one key.
        -- paste = { 'p', '<c-p>' },
        paste_behind = "P",
        replay = "q",
        delete = "d",
        edit = "e",
        custom = {},
      },
    },
  },
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "neoclip"
