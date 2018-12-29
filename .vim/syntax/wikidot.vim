" Vim syntax file
" Language:     Wikidot Syntax
" Maintainer:   Ammon Smith <ammon.i.smith@gmail.com>
" Filenames:    *.wikidot
" Last Change:  2018 December

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'wikidot'
endif

runtime! syntax/html.vim
unlet! b:current_syntax

  syn region  cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cComment2String,cCharacter,cNumbersCom,cSpaceError,cWrongComTail,@Spell


syn match wikidotComment '\[!-- .* --\]'
syn match wikidotElement '\[\[\([^\]]\|\n\)\+\]\]'
syn match wikidotLink '\(\[\[\[\([^\]]\|\n\)\+\]\]\]\|\[\w\+:\/\/\w\+\.\w\+.*\]\)'
syn match wikidotBullet '\s*\*'
syn region wikidotBold matchgroup=wikidotBold start='\*\*' end='\*\*'
syn region wikidotItalic matchgroup=wikidotItalic start='//' end='//'
syn region wikidotUnderline matchgroup=wikidotUnderline start='__' end='__'
syn region wikidotBoldUnderline matchgroup=wikidotBoldUnderline start='\(\*\*__\|__\*\*\)' end='\(\*\*__\|__\*\*\)'
syn region wikidotBoldItalic matchgroup=wikidotBoldItalic start='\(\*\*\/\/\|\/\/\*\*\)' end='\(\*\*\/\/\|\/\/\*\*\)'

syn region wikidotH1 matchgroup=wikidotH1 start='^\s*+' end='$' keepend oneline
syn region wikidotH2 matchgroup=wikidotH2 start='^\s*++' end='$' keepend oneline
syn region wikidotH3 matchgroup=wikidotH3 start='^\s*+++' end='$' keepend oneline
syn region wikidotH4 matchgroup=wikidotH4 start='^\s*++++' end='$' keepend oneline
syn region wikidotH5 matchgroup=wikidotH5 start='^\s*+++++' end='$' keepend oneline
syn region wikidotH6 matchgroup=wikidotH6 start='^\s*++++++' end='$' keepend oneline

highlight def Bold term=bold cterm=bold gui=bold
highlight def Italic term=italic cterm=italic gui=italic
highlight def Underline term=underline cterm=underline gui=underline
highlight def BoldItalic term=bold,italic cterm=bold,italic gui=bold,italic
highlight def BoldUnderline term=bold,underline cterm=bold,underline gui=bold,underline
highlight def ItalicUnderline term=italic,underline cterm=italic,underline gui=italic,underline

highlight default link wikidotComment Comment
highlight default link wikidotElement Structure
highlight default link wikidotLink String
highlight default link wikidotBullet Syntax

highlight default link wikidotBold Bold
highlight default link wikidotItalic Italic
highlight default link wikidotUnderline Underline
highlight default link wikidotBoldItalic BoldItalic
highlight default link wikidotBoldUnderline BoldUnderline
highlight default link wikidotItalicUnderline ItalicUnderline

highlight default link wikidotH1 Title
highlight default link wikidotH2 Title
highlight default link wikidotH3 Title
highlight default link wikidotH4 Title
highlight default link wikidotH5 Title
highlight default link wikidotH6 Title

let b:current_syntax = "wikidot"
if main_syntax ==# 'wikidot'
  unlet main_syntax
endif

" vim:set sw=2:
