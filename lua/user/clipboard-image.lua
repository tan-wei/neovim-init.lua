local status_ok, clipboard_image = pcall(require, "clipboard-image")
if not status_ok then
  return
end

clipboard_image.setup {

  default = {
    img_dir = "images",
    img_name = function()
      vim.fn.inputsave()
      local name = vim.fn.input "Name: "
      vim.fn.inputrestore()
      return name
    end,
    affix = "<\n  %s\n>", -- Multi lines affix
  },

  markdown = {
    img_dir = { "%:p:h", "%:t:r" },
    img_dir_txt = function()
      return { vim.fn["percent#encode"](vim.fn.expand "%:p:h") }
    end,
  },
}
