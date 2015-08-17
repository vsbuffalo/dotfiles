" Plugins through vim-plug
call plug#begin('~/.nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'bfredl/nvim-ipy'
Plug 'Valloric/YouCompleteMe'
Plug 'klen/python-mode'
Plug 'hynek/vim-python-pep8-indent' " change Python's indent to match PEP8
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'tpope/vim-rsi'
Plug 'othree/html5.vim'
call plug#end()

" General configurations
set t_Co=256 " set terminal colors to 256
set number
" edit $MYVIMRC with space e v 
nnoremap <space>ev :vsplit $MYVIMRC<cr>
nnoremap <space>sv :source $MYVIMRC<cr>
let mapleader = '\'
set smartcase
set hidden " allow hidden buffers

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent

" Better buffer switching
nnoremap <C-k> :bnext<CR>
nnoremap <C-j> :bprevious<CR>

" Terminal settings
" Allow for escape to go to normal mode in terminal
tnoremap <Esc> <C-\><C-n>
" allow A-h,j,k,l for movement
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
tnoremap <M-b> <Esc>b
tnoremap <M-f> <Esc>f

" Lightline
let g:lightline = { 'colorscheme': 'wombat', }

" Color schemes
set background=dark
colorscheme Tomorrow-Night
let g:solarized_termcolors=256
"colorscheme solarized

" Custom key mappings
" autofill magic - make a M-q for Vim
nmap <space><space> gwip

" UltiSnip configuration
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Jedi configurations
autocmd FileType python setlocal completeopt-=preview " don't show docstrings

" Pymode settings
let g:pymode_folding = 0

" Sending code to terminal (experimental)
augroup Terminal
  au!
  au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
augroup END

function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction

command! REPLSendLine call REPLSend([getline('.')])

nnoremap <c-l> :REPLSendLine<cr>
inoremap <c-l> :REPLSendLine<cr>





