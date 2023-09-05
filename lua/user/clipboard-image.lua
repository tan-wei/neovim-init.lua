local status_ok, clipboard_image = pcall(require, "clipboard-image")
if not status_ok then
  return
end

clipboard_image.setup {

  default = {
    img_dir = "images",
    img_name = function()
      return os.date "%Y-%m-%d-%H-%M-%S"
    end, -- Example result: "2021-04-13-10-04-18"
    affix = "<\n  %s\n>", -- Multi lines affix
  },

  markdown = {
    img_dir = { "src", "assets", "img" }, -- Use table for nested dir (New feature form PR #20)
    img_dir_txt = "/assets/img",
    img_handler = function(img) -- New feature from PR #22
      local script = string.format('./image_compressor.sh "%s"', img.path)
      os.execute(script)
    end,
  },
}
