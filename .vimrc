" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.

" Set the colorscheme
if has("syntax")
  syntax on
  try
    colorscheme void
  catch
    " Fallback colorschemes
    try
      colorscheme desert
    catch
        colorscheme delek
    endtry
  endtry
endif

" Settings for vim powerline
set laststatus=2
set t_Co=256
let g:powerline_pycmd="py3"

" Set nocompatible vim options
"set cpo=aABceFs<
set nocompatible

" Set utf-8 as the standard encoding
" and en_US as the standard language
set encoding=utf8

" Set Unix as the standard file type
set ffs=unix,dos,mac

" Where split files should go
set splitbelow
set splitright

" Use 4 spaces for tabs
set expandtab
set tabstop=4
set shiftwidth=4

" How many lines of history to remember
set history=1000

" Linebreak at 500 characters
set lbr
set tw=500

" Set relative line numbers
set number
set relativenumber

" Move between windows easier
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>

" Open a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch the cwd to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

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

set autowrite       " Automatically save before commands like :next and :make
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
set showcmd		    " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set smartcase       " Do smart case matching
set smarttab        " Use smart tabbing
set timeoutlen=50   " To prevent the lag on 'O'
set wrap            " Wrap long lines

" Pressing * or # when in visual mode searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<cr>
vnoremap <silent> # :call VisualSelection('b')<cr>

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

" And call it on certain files
if has("autocmd")
  autocmd BufWrite *.c :call DeleteTrailingWS()
  autocmd BufWrite *.py :call DeleteTrailingWS()
endif

" Switch between the two modes when in insert/normal.
"if has("autocmd")
"  autocmd InsertEnter * :call SetAbsoluteNumbers()
"  autocmd InsertLeave * :call SetRelativeNumbers()
"endif

func! EnableSpellCheck()
  setlocal spell spelllang=en_us
endfunc

func! DisableSpellCheck()
  setlocal spell spelllang=
endfunc

" YouCompleteMe options
let g:ycm_global_ycm_extra_conf = '/etc/vim/ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 1

