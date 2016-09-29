#!/bin/sh
set -eu

cd "$(dirname "$0")"
THIS_DIR="$(pwd -P)"
FILES=(
	'.bashrc'
	'.vim'
	'.vimrc'
	'.gvimrc'
	'.zshrc'
	'.zshrc.d'
	'.oh-my-zsh'
)

for filename in "${FILES[@]}"; do
	ln -sv "$THIS_DIR/$filename" "$HOME" || true
done

