" Basic Settings
"
set backupdir=~/.vim-backups " create a different backup file directory
set directory=~/.vim-backups
set nocompatible
syntax enable
set number
set vb " turn off that annoying bell
set hidden " allow hidden buffers
set hlsearch
set wildmenu
set wildmode=longest,list,full
" set cursorline

" Editing ~/.vimrc
" Source the vimrc file after saving it
let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>
" Re-source vimrc
nnoremap <space>s :so $MYVIMRC<cr>
nmap <leader>h :set nohlsearch<CR>

" Fix Vim annoyances
" fix Vim from cursor jumping around when using J
nnoremap J mzJ`z
" don't go into ex mode
nnoremap Q <nop>
" allow backspace anywhere
set backspace=indent,eol,start

" Set path
set path=.,/usr/include/,,./**,/Users/vinceb/Projects/**,/Users/vinceb/Dropbox/**

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
"Bundle 'vim-scripts/OmniCppComplete'
"Bundle 'Rip-Rip/clang_complete'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'garbas/vim-snipmate'
Bundle 'marcweber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
Bundle 'rking/ag.vim'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'sjl/gundo.vim'
Bundle 'vim-scripts/Vim-R-plugin'
Bundle 'altercation/vim-colors-solarized'
Bundle 'mattn/emmet-vim'
Bundle 'aperezdc/vim-template'
Bundle 'Valloric/YouCompleteMe'
"Bundle 'vim-scripts/YankRing.vim'

" directories and settings for snippets and templates
let g:snippets_dir = "~/.vim/snippets"
imap <C-J> <Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger
let g:user = "Vince Buffalo"
let g:license = "BSD"
let g:email = "vsbuffalo@gmail.com"
" disable auto template; use :Template c
let g:templates_no_autocmd = 1

" https://github.com/Valloric/YouCompleteMe/issues/814
set shortmess=a
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/ycm_extra_conf.py'

" omnicomplete
"filetype plugin on
"set omnifunc=syntaxcomplete#Complete

" set omnicomplete for C++
"let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
"let g:clang_library_path=s:clang_library_path
"let g:clang_user_options='|| exit 0'
"let g:clang_complete_auto=1
"let g:clang_complete_copen=1
"let g:clang_hl_errors=1

" LaTeX-Box
let g:LatexBox_latexmk_options = "-pvc -bibtex -pdf"

" General tabs and indents
set tabstop=2
set shiftwidth=2
set softtabstop=2
filetype plugin indent on
"set expandtab
"set autoindent
" Make Vim's tab behave like Emacs when indenting
" from http://smalltalk.gnu.org/blog/bonzinip/emacs-ifying-vims-autoindent
"set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
"set indentkeys=!<Tab>,o,O
"map <Tab> i<Tab><Esc>^
"filetype indent on
"set cinoptions=:0,(0,u0,W1s

" linebreaks and wrapping
set wrap linebreak nolist

" Visual Settings
set ruler
set title
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

" MacVim settings
if has('gui_running')
  set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h11
  " bind command-j and command-k to move between buffers.
  " and command-K and command-J to move between tabs.
  nmap <D-j> :bp <enter>
  nmap <D-k> :bn <enter>
  nmap <D-K> :tabnext <enter>
  nmap <D-J> :tabprevious <enter>
else
  nmap <C-j> :bp <enter>
  nmap <C-k> :bn <enter>
endif

" Searching
set smartcase
set incsearch

" Powerline
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
set encoding=utf-8 " Necessary to show Unicode glyphs
let g:Powerline_symbols = 'fancy'
set laststatus=2   " Always show the statusline

" Custom keybinding
" resize current buffer by +/- 5
nnoremap <M-Right> :vertical resize +5<CR>
nnoremap <M-Left>  :vertical resize -5<CR>
nnoremap <M-Up>    :resize -5<CR>
nnoremap <M-Down>  :resize +5<CR>
" Faster mapping for saving - thanks Paradigm
nnoremap <space>w :w<cr>
" Run wrapper for :make
nnoremap <space>m :Make<cr>
" insert new lines with enter and shift enter.
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k
" autofill magic - make a M-q for Vim
nmap <space><space> gwip

" ctlp
" set runtimepath^=~/.vim/bundle/ctrlp.vim
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

" Format options
set nojoinspaces
" autocmd FileType asciidoc setlocal formatoptions+=ta

" Spelling
" Toggle spell checking on and off with `,s`
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_us
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
" set the spellfile
set spellfile=~/.vim/spell/en.utf-8.add

" turn off arrow keys - their use is a vim anti-pattern
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Common mistyped words and abbreviations
iabbrev het heterozygous
iabbrev hom homozygous

" R script settings
let maplocalleader = ","
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine
let vimrplugin_applescript=0
let vimrplugin_vsplit=1
let rrst_syn_hl_chunk = 1
let rmd_syn_hl_chunk = 1

" turn off searching include files during autocomplete
set complete-=i

" emmet: uncomment just for html/css
let g:user_emmet_install_global = 1
autocmd FileType html,css EmmetInstall

" putting these last seems to help solve issues (silly Vim).
filetype off
filetype on

" youcomplete me blacklist
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'asciidoc' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}

