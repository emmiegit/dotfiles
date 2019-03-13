#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
this_dir="$(pwd -P)"
flags=('-sv')
files=(
	'.bashrc'
	'.vim'
	'.vimrc'
	'.gitconfig'
	'.gvimrc'
	'.zshrc'
	'.oh-my-zsh'
)

for arg in "$@"; do
	case "$arg" in
		-f)
			flags+=('-f')
			;;
		--force)
			flags+=('-f')
			;;
		*)
			printf >&2 'Unknown argument: %s\n' "$arg"
			exit 1
			;;
	esac
done

for filename in "${files[@]}"; do
	ln "${flags[@]}" "$this_dir/$filename" "$HOME" || true
done
