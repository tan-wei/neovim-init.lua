vim.g.bootstrap_skip_treesitter_install = true

vim.api.nvim_create_augroup("matchparen", { clear = true })
vim.api.nvim_create_augroup("FileExplorer", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("BootstrapPreinit", { clear = true }),
	callback = function()
		local ok, installer = pcall(require, "mason-tool-installer")
		if not ok then
			return
		end

		installer.setup {
			auto_update = false,
			run_on_start = false,
			start_delay = 0,
			debounce_hours = nil,
		}
	end,
})
