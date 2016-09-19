" Vim syntax file
" Language:     "TextReceipt"
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
syn match txtlistBullet            "^[\t ]*\*"
syn match txtreceiptMoney          "\$[0-9.]\+"
syn match txtreceiptStore          "^\[[^\n]\{2,\}\]"
syn region txtreceiptComment       start="\s*#" end="$"

" Keywords
syn keyword txtreceiptTodo TODO FIXME

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_txtreceipt_syn_inits")
	if version < 508
		let did_txtreceipt_syn_inits = 1
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

        HiLink txtreceiptStore     Identifier
        HiLink txtreceiptBullet    Define
        HiLink txtreceiptMoney     Constant

        HiLink txtreceiptLabel     Statement
        HiLink txtreceiptBullet    Define
        HiLink txtreceiptComment   Comment
        HiLink txtreceiptTodo      Todo

	delcommand HiLink
endif

let b:current_syntax = "txtreceipt"

" vim: ts=8 sw=2:
