---@type LazyPluginSpec
local M = {
  "HakonHarnes/img-clip.nvim",
  ft = { "markdown" },
  enabled = false,
}

M.opts = {
  default = {
    file_name = function()
      vim.fn.inputsave()
      local name = vim.fn.input "Name: "
      vim.fn.inputrestore()
      return name
    end,
    prompt_for_file_name = false,
    insert_mode_after_paste = false,
    drag_and_drop = {
      enabled = false,
    },
  },
  filetypes = {
    markdown = {
      dir_path = function()
        return vim.fs.joinpath(vim.fn.expand "%:p:h", vim.fn.expand "%:t:r")
      end,
      relative_template_path = true,
      url_encode_path = true,
      download_images = false,
      template = "<\n  ./$FILE_PATH\n>",
    },
  },
}

M.config = function(_, opts)
  require("img-clip").setup(opts)

  pcall(vim.api.nvim_del_user_command, "PasteImg")
  vim.api.nvim_create_user_command("PasteImg", function()
    require("img-clip").paste_image()
  end, { desc = "Paste image from system clipboard" })
end

return M
