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

" vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'Rip-Rip/clang_complete'
Bundle 'terryma/vim-multiple-cursors'

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
nmap <D-j> :bp <enter> 
nmap <D-k> :bn <enter>
" resize current buffer by +/- 5
nnoremap <M-Right> :vertical resize +5<CR>
nnoremap <M-Left>  :vertical resize -5<CR>
nnoremap <M-Up>    :resize -5<CR>
nnoremap <M-Down>  :resize +5<CR>

" ctlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Spelling
" Toggle spell checking on and off with `,s`
let mapleader = ","
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_us
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
