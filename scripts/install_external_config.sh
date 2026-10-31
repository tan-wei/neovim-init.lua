#!/usr/bin/env bash
set -euo pipefail

tool="${1:?Usage: install_external_config.sh <kitty|ghostty|alacritty|wezterm>}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

detect_platform() {
	case "$(uname -s)" in
		Darwin)
			printf '%s\n' macos
			;;
		Linux)
			if [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" || "$(uname -r)" == *[Mm]icrosoft* ]]; then
				printf '%s\n' wsl
			else
				printf '%s\n' linux
			fi
			;;
		*)
			printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
			return 1
			;;
	esac
}

platform="${DOTFILES_PLATFORM:-$(detect_platform)}"
case "$platform" in
	linux|macos|wsl) ;;
	*)
		printf 'Unsupported platform: %s (expected linux, macos, or wsl)\n' "$platform" >&2
		exit 1
		;;
esac

source_dir="$repo_root/external/config/$tool"
destination_dir="$config_home/$tool"
if [[ ! -d "$source_dir" ]]; then
	printf 'Unknown external config: %s\n' "$tool" >&2
	exit 1
fi

if [[ -L "$destination_dir" ]]; then
	source_real_dir="$(cd "$source_dir" && pwd -P)"
	destination_real_dir="$(cd "$destination_dir" && pwd -P)"
	if [[ "$destination_real_dir" == "$source_real_dir" ]]; then
		rm "$destination_dir"
	fi
fi

mkdir -p "$destination_dir"
case "$tool" in
	kitty)
		cp -f "$source_dir/kitty.conf" "$destination_dir/kitty.conf"
		cp -f "$source_dir/$platform.conf" "$destination_dir/platform.conf"
		;;
	ghostty)
		cp -f "$source_dir/config.ghostty" "$destination_dir/config.ghostty"
		cp -f "$source_dir/$platform.ghostty" "$destination_dir/platform.ghostty"
		;;
	alacritty)
		cp -f "$source_dir/alacritty.toml" "$destination_dir/alacritty.toml"
		cp -f "$source_dir/$platform.toml" "$destination_dir/platform.toml"
		;;
	wezterm)
		cp -f "$source_dir/wezterm.lua" "$destination_dir/wezterm.lua"
		mkdir -p "$destination_dir/platform"
		cp -R "$source_dir/platform/." "$destination_dir/platform/"
		;;
	*)
		printf 'No installer is defined for: %s\n' "$tool" >&2
		exit 1
		;;
esac

printf 'Installed %s config for %s in %s\n' "$tool" "$platform" "$destination_dir"