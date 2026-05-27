set shell := ["bash", "-uc"]

default:
	@just --list

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