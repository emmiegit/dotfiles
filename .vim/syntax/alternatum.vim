" Vim syntax file
" Language:     "Alternatum Markup"
" Author:       Ammon Smith
" License:      CC0

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore
syn sync minlines=5

" Expressions
syn match alternatumLabel               "^[^()\[\]\n]\+:"
syn match alternatumBullet              "^[\t ]*\*"
syn match alternatumModifier            "\(1A\|1B\|1C\|1D\|2A\|2B\|2C\)+\?"
syn region alternatumComment            start="#" end="$"

" Keywords
syn keyword alternatumTodo     TODO FIXME

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_alternatum_syn_inits")
	if version < 508
		let did_alternatum_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

        " Valid colors:
        " Comment
        " Constant
        " Define
        " Delimiter
        " Float
        " Identifier
        " Number
        " Operator
        " PreProc
        " Statement
        " String
        " Todo
        " Type

        HiLink alternatumLabel          Delimiter
        HiLink alternatumModifier       Constant
        HiLink alternatumBullet         Type
        HiLink alternatumComment        Comment
        HiLink alternatumTodo           Todo

	delcommand HiLink
endif

let b:current_syntax = "alternatum"

" vim: ts=8 sw=2
