set shell := ["bash", "-uc"]

bootstrap_preinit := "lua dofile(vim.fn.fnamemodify('./scripts/bootstrap_preinit.lua', ':p'))"

default:
	@just --list

stylua:
	@stylua .

stylua-check:
	@stylua --check .

keymap-audit:
	@nvim --headless \
		--cmd "lua dofile(vim.fn.fnamemodify('./scripts/keymap_audit.lua', ':p'))" \
		"+lua _G.__keymap_audit_finalize()" \
		+qa!

keymap-audit-check:
	@KEYMAP_AUDIT_FAIL_ON_CONFLICT=1 nvim --headless \
		--cmd "lua dofile(vim.fn.fnamemodify('./scripts/keymap_audit.lua', ':p'))" \
		"+lua _G.__keymap_audit_finalize()" \
		+qa!

bootstrap-lazy:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+Lazy! sync" \
		+qa!

bootstrap-treesitter:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua require('user.bootstrap').treesitter_sync()" \
		+qa!

bootstrap-mason:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua require('user.bootstrap').mason_sync()" \
		+qa!

bootstrap-smoke:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua require('user.bootstrap').startup_smoke()" \
		+qa!

bootstrap:
	@just bootstrap-lazy
	@just bootstrap-treesitter
	@just bootstrap-mason
	@just bootstrap-smoke