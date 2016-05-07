" Vim syntax file
" Language:     LC-3 Assembly
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
syn match lc3Label              "[a-zA-Z0-9_]\+"
syn match lc3Register           "[rR][0-7]"
syn match lc3PseudoOp           "\.[a-zA-Z]\+"
syn match lc3Decimal            "#-\?[0-9]\+"
syn match lc3Hex                "-\?x[0-9a-fA-F]\+"
syn region lc3String            start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region lc3Comment           start=";" end="$"

" Keywords
syn keyword lc3Opcode add and br brn brz brp brnz brzp brnp brnzp getc in
syn keyword lc3Opcode jmp jsr jsrr ld ldb ldi ldr ldw lea lshf halt not
syn keyword lc3Opcode out puts ret rti rshfa rshfl shf st stb sti str trap

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lc3_syn_inits")
	if version < 508
		let did_lc3_syn_inits = 1
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

        HiLink lc3Register      Type
        HiLink lc3Decimal       Number
        HiLink lc3Hex           Number
        HiLink lc3PseudoOp      Define
        HiLink lc3String        String
        HiLink lc3Comment       Comment
        HiLink lc3Label         Identifier
        HiLink lc3Opcode        Statement

	delcommand HiLink
endif

let b:current_syntax = "lc3"
" vim: ts=8 sw=2
