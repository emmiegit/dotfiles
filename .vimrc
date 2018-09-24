"""""""""
" vimrc "
"""""""""

" General options {{{
"""""""""""""""""""""
set autoread              " Set to auto read when a file is changed
set autowrite             " Automatically save before commands like :next and :make
set backupcopy=yes        " Preserve hard links when making copies
set confirm               " Instead of failing a command, raise a dialog asking what to do
set encoding=utf8         " Set default encoding
set fileformats=unix,dos  " Set Unix as the standard line ending
set foldlevelstart=3      " How many folds to show at file open
set hidden                " Hide buffers when they are abandoned
set hlsearch              " Highlight matches when searching
set incsearch             " Incremental search
set lazyredraw            " Don't redraw when running macros
set magic                 " Use traditional regular expressions (see wiki)
set matchtime=1           " How many tenths of a second to blink when matching brackets
set mouse=n               " Enable mouse usage (normal mode only)
set nocompatible          " Disable vi compatibility options
set noshowmode            " Powerline does this for me, so disable the default mode
set nosmartindent         " Prevent audo dedent on Python comment
set relativenumber        " Use relative line numbers (see below)
set ruler                 " Display the bar at the bottom 
set secure                " Shell and write commands are disallowed in local vimrcs
set showcmd               " Show (partial) command in status line
set showmatch             " Show matching brackets
set smartcase             " Do smart case matching
set smarttab              " Use smart tabbing
set tabpagemax=500        " Maximum number of tabs
set timeoutlen=50         " To prevent the lag on 'O'
set undolevels=10000      " Allow for 10,000 undos
set wrap                  " Wrap long lines

" Set leader key
let mapleader = '\'
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
set linebreak
set textwidth=500

" Set relative line numbers
set number
set relativenumber
" }}}

" Behavior settings {{{
"""""""""""""""""""""""
" Where split files should go
set splitbelow
set splitright

" Only time out on keybinds, not mappings
set notimeout
set ttimeout

" How many lines of history to remember
set history=1000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Swap files
try
  set directory=~/.vim_runtime/swap
catch
endtry

" Backup files
try
  set backup
  set backupdir=~/.vim_runtime/backups
  set writebackup
catch
endtry

" Undo files
try
  set undodir=/tmp/ammon/vim_undo
  set undofile
catch
endtry

" Use 4 spaces for tabs
" See the 'file-specific settings' section for file types
" that override these settings.
set expandtab
set tabstop=4
set shiftwidth=4

" Print whitespace
set list listchars=tab:»\ ,trail:·

" Set the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" Enable auto indent
set ai

" Turn off physical line wrapping (i.e. the automatic insert of newlines)
set textwidth=0
set wrapmargin=0

" Have backspace actually go backwards
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Allow tab completion in the menu
set wildmode=longest,list,full
set wildmenu
set wildignore=*.o,*.d,*.so,*~,*.pyc,.git

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
vnoremap j gj
vnoremap k gk

" Have Y act like C and D rather than yy
map Y y$

" Have <C-l> also turn of search highlighting
nnoremap <C-l> :nohl<cr><C-l>

" Remove ^M from Windows newlines
noremap <leader>dos mmHmt:%s/<C-v><cr>//ge<cr>'tzt'm

" Set :grep to use ripgrep
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
" }}}

" New commands {{{
""""""""""""""""""
" :W sudo saves the file
command W w !sudo tee % > /dev/null

" :Y copies an entire file
command Y ggVG"+p``

" :Cstyle sets my preferred formatting for C programs
command Cstyle set cindent shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab

" :Path prints the full path of the current buffer
command Path :echo expand('%:p')

" Save session
command SessionSave :mksession<cr>

" Search for merge conflict markers
command MergeFail :/^\(<<<<<<<\|=======\|>>>>>>>\)

" Open all buffers as separate tabs
" Useful if vim is invoked without -p
command BuffersToTabs :bufdo tab split

" Move between windows easier
nnoremap <SID> <Plug>IMAP_JumpForward

" Open a newline without going into insert mode
nmap <cr> o<esc>

" Pressing * or # when in visual mode searches for the current selection
vnoremap <silent> * :<c-u>
  \let old_reg=getreg('"')<bar>let old_regtype=getregtype('"')<cr>
  \gvy/<c-r><c-r>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gV:call setreg('"', old_reg, old_regtype)<cr>
vnoremap <silent> # :<c-u>
  \let old_reg=getreg('"')<bar>let old_regtype=getregtype('"')<cr>
  \gvy?<c-r><c-r>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gV:call setreg('"', old_reg, old_regtype)<cr>

" Highlight last inserted text
nnoremap gV `[v`]

" Close all hidden buffers
function! CloseHiddenBuffers()
  let visible = {}
  " fetch visible tabs
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any loaded buffers that are not visible
  for b in range(1, bufnr('$'))
    if bufloaded(b) && !has_key(visible, b)
      exe 'bd ' . b
    endif
  endfor
endfun

command CloseBufs :call CloseHiddenBuffers()

" Close the current buffer
cmap <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>

" Open a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch the cwd to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Move a line of text using SHIFT+ALT+[jk]
nmap <M-S-j> mz:m+<cr>`z
nmap <M-S-k> mz:m-2<cr>`z
vmap <M-S-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-S-k> :m'<-2<cr>`>my`<mzgv`yo`z

" ss toggles spellcheck
map <leader>ss :setlocal spell!<cr>

" System clipboard
nmap <leader>p "+p
nmap <leader>P "+P
nmap <leader>y "+y
nmap <leader>x "+x
nmap <leader>d "+d
vmap <leader>p "+p
vmap <leader>P "+P
vmap <leader>y "+y
vmap <leader>x "+x
vmap <leader>d "+d

" }}}

" Plugin settings {{{
"""""""""""""""""""""
" Settings for vim powerline
set laststatus=2
set t_Co=256
let g:powerline_pycmd = 'py3'

" rust.vim
let g:autofmt_autosave = 1

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

"let g:javascript_conceal_function             = "ƒ"
"let g:javascript_conceal_null                 = "ø"
"let g:javascript_conceal_this                 = "@"
"let g:javascript_conceal_return               = "⇚"
"let g:javascript_conceal_undefined            = "¿"
"let g:javascript_conceal_NaN                  = "ℕ"
"let g:javascript_conceal_prototype            = "¶"
"let g:javascript_conceal_static               = "•"
"let g:javascript_conceal_super                = "Ω"
"let g:javascript_conceal_arrow_function       = "⇒"
"let g:javascript_conceal_noarg_arrow_function = "🞅"
"let g:javascript_conceal_underscore_arrow_function = "🞅"

" LaTeX settings
let g:tex_flavor = 'latex'
let g:Imap_UsePlaceHolders = 0

" YouCompleteMe options
let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_server_python_interpreter = '/usr/bin/python2'
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_rust_src_path = expand('$HOME') . '/Documents/Relic/Git/rust/src'
let g:EclimCompletionMethod = 'omnifunc'
let g:tern_show_argument_hints = 'on_hold'
let g:tern_map_keys = 1

" Local vimrc
let g:localvimrc_reverse = 1
let g:localvimrc_count = 1
let g:localvimrc_persistent = 2
let g:localvimrc_persistence_file = expand('$HOME') . '/.vim_runtime/localvimrc_persist'

" Only source .lvimrc files in ~/Git
let g:localvimrc_blacklist = '.*'
let g:localvimrc_whitelist = [expand('$HOME') . '/Git/.*']
" }}}

" Helper functions {{{
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
  autocmd BufWrite *.cc :call DeleteTrailingWS()
  autocmd BufWrite *.cpp :call DeleteTrailingWS()
  autocmd BufWrite *.h :call DeleteTrailingWS()
  autocmd BufWrite *.hh :call DeleteTrailingWS()
  autocmd BufWrite *.hpp :call DeleteTrailingWS()
  autocmd BufWrite *.go :call DeleteTrailingWS()
  autocmd BufWrite *.py :call DeleteTrailingWS()
  autocmd BufWrite *.rs :call DeleteTrailingWS()
  autocmd BufWrite *.java :call DeleteTrailingWS()
  autocmd BufWrite *.js :call DeleteTrailingWS()
  autocmd BufWrite *.tex :call DeleteTrailingWS()
  autocmd BufWrite *.ts :call DeleteTrailingWS()
  autocmd BufWrite *.txt :call DeleteTrailingWS()
  autocmd BufWrite Makefile :call DeleteTrailingWS()
endif

func! OpenTabs(...)
  for filename in a:000
    :tabnew &filename
  endfor
endfunc

" }}}

" File-Specific Settings {{{
autocmd BufRead *.c setl cindent shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab textwidth=80 foldmethod=syntax
autocmd BufRead *.cc setl cindent foldmethod=syntax
autocmd BufRead *.cpp setl cindent foldmethod=syntax
autocmd BufRead *.go setl shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab textwidth=72 foldmethod=syntax
autocmd BufRead *.h setl cindent shiftwidth=8 tabstop=8 softtabstop=8 noexpandtab textwidth=80 foldmethod=syntax filetype=c
autocmd BufRead *.hh setl cindent foldmethod=syntax
autocmd BufRead *.hpp setl cindent foldmethod=syntax
autocmd BufRead *.hbs setl shiftwidth=2 tabstop=2 foldmethod=indent
autocmd BufRead *.js setl shiftwidth=2 tabstop=2 foldmethod=syntax conceallevel=1
autocmd BufRead *.ts setl shiftwidth=2 tabstop=2 filetype=javascript
autocmd BufRead *.css setl cindent foldmethod=syntax
autocmd BufRead *.scss setl shiftwidth=2 tabstop=2 foldmethod=indent
autocmd BufRead *.py setl foldmethod=indent
autocmd BufRead *.rs setl foldmethod=syntax
autocmd BufRead *.sh setl shiftwidth=4 tabstop=4 foldmethod=indent makeprg=shellcheck\ -f\ gcc\ % noexpandtab
autocmd BufRead *.tex setl nowrap
autocmd BufRead *.yaml setl shiftwidth=2 tabstop=2 foldmethod=indent
autocmd BufRead *.yml setl shiftwidth=2 tabstop=2 foldmethod=indent

" Secure editing of passwords with 'pass'
autocmd BufReadPre,FileReadPre /dev/shm/pass.*.txt set viminfo=
autocmd BufReadPre,FileReadPre /dev/shm/pass.*.txt set noswapfile noundofile nobackup

" Transparent GPG Encryption
augroup gpg_encrypted
  au!

  " Disable options that write the plaintext to disk
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup

  " Switch to binary mode
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Encrypt all text before writing
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2> /dev/null

  " Undo the encryption so we can edit again
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END
" }}}

" vim: set ts=2 sw=2 fdm=marker foldlevel=0:
