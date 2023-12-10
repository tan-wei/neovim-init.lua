local M = {
  "CRAG666/code_runner.nvim",
  dependencies = {
    "jedrzejboczar/toggletasks.nvim",
  },
  cmd = {
    "RunCode",
    "RunFile",
    "RunProject",
    "RunClose",
    "CRFiletype",
    "CRProjects",
  },
}

M.config = function()
  require("code_runner").setup {
    mode = "toggleterm",
    filetype = {
      javascript = "node",
      java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
      kotlin = "cd $dir && kotlinc-native $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt.kexe",
      c = {
        "cd $dir &&",
        "gcc $fileName -o",
        "/tmp/$fileNameWithoutExt &&",
        "/tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      },
      cpp = {
        "cd $dir &&",
        "g++ $fileName",
        "-o /tmp/$fileNameWithoutExt &&",
        "/tmp/$fileNameWithoutExt",
      },
      python = "python -u '$dir/$fileName'",
      sh = "bash",
      typescript = "deno run",
      typescriptreact = "yarn dev$end",
      rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
      dart = "dart",
      cs = function(...)
        local root_dir = require("null-ls.utils").root_pattern "*.csproj"(vim.loop.cwd())
        return "cd " .. root_dir .. " && dotnet run$end"
      end,
    },
    -- project_path = vim.fn.expand "~/.config/nvim/project_manager.json",
  }
end

-- TODO: Add them to whichkey
-- vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>crf', ':CRFiletype<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>crp', ':CRProjects<CR>', { noremap = true, silent = false })

return M
