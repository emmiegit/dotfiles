" Vim syntax file
" Language:     antz Assembly
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
syn match antzLabel              "[a-zA-Z0-9_]\+:"
syn match antzPseudoOp           "\.[a-zA-Z]\+"
syn match antzDecimal            "\( \|^\)-\?[0-9]\+"
syn match antzHex                "\( \|^\)-\?0x[0-9a-fA-F]\+"
syn match antzBinary             "-\?0b[01]\+"
syn match antzChar               "'\(\\\([\\nrbtfv]\|x[A-Fa-f0-9]\{2\}\|[0-7]\{3\}\)\|[^\\\n]\)'"
syn region antzString            start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region antzComment           start=";" end="$"

" Keywords
syn keyword antzTodo TODO FIXME

syn keyword antzRegister r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 rio rrt rer rpc

syn keyword antzOpcode add and call cmp div fadd fdiv fmul fneg
syn keyword antzOpcode jez jge jgz jle jlz jmp jnz ld ldb ldi ldr lea
syn keyword antzOpcode lshf mod mov mul nop not or ret rshf set st stb sti str
syn keyword antzOpcode sub trap xor
syn keyword antzOpcode getc putc mvcur clscr puts halt

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_antz_syn_inits")
	if version < 508
		let did_antz_syn_inits = 1
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

        HiLink antzTodo          Todo
        HiLink antzRegister      Type
        HiLink antzDecimal       Number
        HiLink antzHex           Number
        HiLink antzBinary        Number
        HiLink antzPseudoOp      Define
        HiLink antzChar          String
        HiLink antzString        String
        HiLink antzComment       Comment
        HiLink antzLabel         Identifier
        HiLink antzOpcode        Statement

	delcommand HiLink
endif

let b:current_syntax = "antz"
" vim: ts=8 sw=2
