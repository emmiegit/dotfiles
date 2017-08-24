" Vim Indentation File
" Language: Odin
" Maintainer: Tyler Erickson
" Latest Revision: 16 Aug 2017

" This indentation is likely very incomplete, 
" I will be adding indentation rules as I use the language more

if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal indentkeys+==},=),0\\
setlocal indentexpr=GetOdinIndent()

let b:undo_indent = "setl cin<"

" Only define the function once.
if exists("*GetOdinIndent")
  finish
endif

let s:keepcpo= &cpo
set cpo&vim

function! SkipBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~ '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~ '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~ '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function GetOdinIndent() 
  let cur_text = getline(v:lnum)

  let prev_ln = SkipBlanksAndComments(v:lnum - 1)
  let prev_text = getline(prev_ln)

  let indent = indent(prev_ln)

  if prev_text =~ '^.*{[^}]*$'
    let indent = indent + shiftwidth()
  endif

  if prev_text =~ '^.*([^)]*$'
    let indent = indent + shiftwidth()
  endif

  if cur_text =~ '^[^{]*}.*$'
    let indent = indent - shiftwidth()
  endif

  if cur_text =~ '^[^(]*).*$'
    let indent = indent - shiftwidth()
  endif

  return indent
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo

" vi: sw=2 et
