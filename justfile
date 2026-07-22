set shell := ["bash", "-uc"]

bootstrap_preinit := "lua dofile(vim.fn.fnamemodify('./scripts/bootstrap_preinit.lua', ':p'))"
bootstrap_helper := "dofile(vim.fn.fnamemodify('./scripts/bootstrap.lua', ':p'))"

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

keymap-docs:
	@nvim --headless \
		--cmd "lua dofile(vim.fn.fnamemodify('./scripts/keymap_docs.lua', ':p'))" \
		+qa!

keymap-docs-check:
	@KEYMAP_DOCS_FAIL_ON_MISSING=1 nvim --headless \
		--cmd "lua dofile(vim.fn.fnamemodify('./scripts/keymap_docs.lua', ':p'))" \
		+qa!

link-check:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua dofile(vim.fn.fnamemodify('./scripts/link_check.lua', ':p')).check()" \
		+qa!

colorscheme-check:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua dofile(vim.fn.fnamemodify('./scripts/colorscheme_check.lua', ':p')).check()" \
		+qa!

health-check:
	@nvim --headless \
		"+lua dofile(vim.fn.fnamemodify('./scripts/health_check.lua', ':p')).check()" \
		+qa!

treesitter-audit:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua dofile(vim.fn.fnamemodify('./scripts/treesitter_audit.lua', ':p')).check()" \
		+qa!

bootstrap-lazy:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+Lazy! sync" \
		+qa!

bootstrap-treesitter:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua {{bootstrap_helper}}.treesitter_sync()" \
		+qa!

bootstrap-mason:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua {{bootstrap_helper}}.mason_sync()" \
		+qa!

bootstrap-smoke:
	@nvim --headless \
		--cmd "{{bootstrap_preinit}}" \
		"+lua {{bootstrap_helper}}.startup_smoke()" \
		+qa!

bootstrap:
	@just bootstrap-lazy
	@just bootstrap-treesitter
	@just bootstrap-mason
	@just bootstrap-smoke