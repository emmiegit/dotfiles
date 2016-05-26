"""""""""
" vimrc "
"""""""""

" Standard options {{{
""""""""""""""""""""""
"
" Disable vi compatibility options
"set cpo=aABceFs<
set nocompatible

" Set utf-8 as the standard encoding
" and en_US as the standard language
set encoding=utf8

" Set Unix as the standard file type
set ffs=unix,dos,mac

set autoread        " Set to auto read when a file is changed
set autowrite       " Automatically save before commands like :next and :make
set confirm         " Instead of failing a command, raise a dialog asking what to do
set hidden          " Hide buffers when they are abandoned
set hlsearch        " Highlight matches when searching
set incsearch       " Incremental search
set lazyredraw      " Don't redraw when running macros
set magic           " Use traditional regular expressions (see wiki)
set mat=2           " How many tenths of a second to blink when matching brackets
set mouse=n         " Enable mouse usage (normal mode only)
set noshowmode      " Powerline does this for me, so I don't need two modes.
set nosmartindent   " Prevent audo dedent on Python comment
set relativenumber  " Use relative line numbers (see below)
set ruler           " Display the bar at the bottom 
set showcmd		      " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set smartcase       " Do smart case matching
set smarttab        " Use smart tabbing
set timeoutlen=50   " To prevent the lag on 'O'
set wrap            " Wrap long lines
" }}}

" Appearance {{{
""""""""""""""""
" Set the colorscheme
if has("syntax")
  syntax on
  try
    colorscheme void
  catch
    " Fallback colorscheme
    colorscheme delek
  endtry
endif
"
" Linebreak at 500 characters
set lbr
set tw=500

" Set relative line numbers
set number
set relativenumber

" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
" }}}

" Behavior settings {{{
"""""""""""""""""""""""
" Where split files should go
set splitbelow
set splitright

" How many lines of history to remember
set history=1000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Backup settings
set backup
set backupdir=~/.vim_runtime/backups
set writebackup

" Allow you to do undoes even when you close vim
try
  set undodir=/tmp/ammon/vim_undo
  set undofile
catch
endtry

" Use 4 spaces for tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Set the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Enable auto indent and smart indent
set ai
set si

" Turn off physical line wrapping (i.e. the automatic insert of newlines)
set textwidth=0
set wrapmargin=0

" Have backspace actually go backwards
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Allow tab completion in the menu
set wildmode=longest,list,full
set wildmenu
set wildignore=*.o,*.d,*~,*.pyc,.git

" Set viminfo
set viminfo=%,\"100,'10,/50,:100,h,f0,n~/.viminfo

" Have vim jump to the last location when opening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have vim load indent rules and plugins
if has("autocmd")
  filetype plugin indent on
endif

" Set number of lines to the cursor when moving vertically
if (&lines > 35)
  set scrolloff=9     
else
  set scrolloff=2
endif
" }}}

" Modified commands {{{
"""""""""""""""""""""""
" Move by visual line
nnoremap j gj
nnoremap k gk

" Have Y act like C and D rather than yy
map Y y$

" Have <C-l> also turn of search highlighting
nnoremap <C-l> :nohl<cr><C-l>

" Remove ^M from Windows newlines
noremap <leader>m mmHmt:%s/<C-v><cr>//ge<cr>'tzt'm
" }}}

" New commands {{{
""""""""""""""""""
" :W sudo saves the file
command W w !sudo tee % > /dev/null

" Move between windows easier
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Pressing * or # when in visual mode searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<cr>
vnoremap <silent> # :call VisualSelection('b')<cr>

" Highlight last inserted text
nnoremap gV `[v`]

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

"" Useful mappings for managing tabs
"map <leader>tn :tabnew<cr>
"map <leader>to :tabonly<cr>
"map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove<cr>

" Open a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch the cwd to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" :ss toggles spellcheck
map <leader>ss :setlocal spell!<cr>

" Save session
nnoremap <leader>s :mksession<cr>
" }}}

" Plugin settings {{{
"""""""""""""""""""""
" Settings for vim powerline
set laststatus=2
set t_Co=256
let g:powerline_pycmd="py3"

" Set blank .tex files to be LaTeX
let g:tex_flavor='latex'

" YouCompleteMe options
let g:ycm_global_ycm_extra_conf = '/etc/vim/ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 1
" }}}

" Helper Functions {{{
""""""""""""""""""""""
" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

" And call it on certain files
if has("autocmd")
  autocmd BufWrite *.c :call DeleteTrailingWS()
  autocmd BufWrite *.cpp :call DeleteTrailingWS()
  autocmd BufWrite *.h :call DeleteTrailingWS()
  autocmd BufWrite *.hpp :call DeleteTrailingWS()
  autocmd BufWrite *.py :call DeleteTrailingWS()
  autocmd BufWrite Makefile :call DeleteTrailingWS()
endif

func! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunc

func! VisualSelection()
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ag \"" . l:pattern . "\" " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunc
" }}}

" vim: set ts=2 sw=2 foldmethod=marker foldlevel=0: