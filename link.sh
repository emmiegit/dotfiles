#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
this_dir="$(pwd -P)"
flags=()
files=(
	'.bashrc'
	'.vim'
	'.vimrc'
	'.gvimrc'
	'.zshrc'
	'.zshrc.d'
	'.oh-my-zsh'
)

if [[ "$1" == '-f' ]] || [[ "$1" == '--force' ]]; then
	flags+=('-f')
fi

for filename in "${files[@]}"; do
	ln -sv "${flags[@]}" "$this_dir/$filename" "$HOME" || true
done

