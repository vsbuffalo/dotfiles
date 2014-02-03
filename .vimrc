" Basic Settings
set nocompatible
filetype off
syntax enable
set background=dark
colorscheme solarized
set number
set vb " turn off that annoying bell
set hidden " allow hidden buffers
set hlsearch

" Editing ~/.vimrc
" Source the vimrc file after saving it
let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>
" Re-source vimrc
nnoremap <space>s :so $MYVIMRC<cr>

" Set path
set path=.,/usr/include/,,./**,/Users/vinceb/Projects/,/Users/vinceb/Dropbox/

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'vim-scripts/OmniCppComplete'
Bundle 'Rip-Rip/clang_complete'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'marcweber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'rking/ag.vim'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'sjl/gundo.vim'

" omnicomplete
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" set omnicomplete for C++
let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
endif
" LaTeX-Box
let g:LatexBox_latexmk_options = "-pvc -bibtex -pdf"

" General tabs and indents
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
" Make Vim's tab behave like Emacs when indenting
" from http://smalltalk.gnu.org/blog/bonzinip/emacs-ifying-vims-autoindent
set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
set indentkeys=!<Tab>,o,O
map <Tab> i<Tab><Esc>^
filetype indent on
set cinoptions=:0,(0,u0,W1s

" linebreaks and wrapping
set wrap linebreak nolist

" Visual Settings
set guifont=Monaco:h11
set ruler
set title
set wildmenu
set wildmode=longest,list,full

" MacVim settings
if has('gui_running')
  set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h11
  " bind command-j and command-k to move between buffers.
  " and command-K and command-J to move between tabs.
  nmap <D-j> :bp <enter>
  nmap <D-k> :bn <enter>
  nmap <D-K> :tabnext <enter>
  nmap <D-J> :tabprevious <enter>
endif

" Searching
set ignorecase
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
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Format options
set nojoinspaces
autocmd FileType asciidoc setlocal formatoptions+=ta

" Spelling
" Toggle spell checking on and off with `,s`
let mapleader = ","
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
