" Basic Settings
syntax enable
set background=dark
colorscheme solarized
set number
set vb " turn off that annoying bell
set hidden " allow hidden buffers

" Tabs and Indents
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" linebreaks and wrapping
set wrap linebreak nolist

" Visual Settings
set guifont=Monaco:h11
set ruler 
set title
set wildmenu 
set wildmode=longest,list,full
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11
endif

" Powerline
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/
set encoding=utf-8 " Necessary to show Unicode glyphs
let g:Powerline_symbols = 'fancy'
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline

" Custom keybinding
" bind command-j and command-k to move between buffers.
map <D-j> <esc> :bp <enter> 
map <D-k> <esc> :bn <enter>

" ctlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

