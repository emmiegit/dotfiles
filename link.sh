#!/bin/sh
set -e

cd "$(dirname "$0")"
THIS_DIR="$(pwd -P)"
FLAGS=
FILES=(
	'.bashrc'
	'.vim'
	'.vimrc'
	'.gvimrc'
	'.zshrc'
	'.zshrc.d'
	'.oh-my-zsh'
)

if [ "$1" == "-f" -o "$1" == "--force" ]; then
	FLAGS='-f'
fi

for filename in "${FILES[@]}"; do
	ln -sv $FLAGS "$THIS_DIR/$filename" "$HOME" || true
done

