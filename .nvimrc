
call plug#begin('~/.nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'airblade/vim-gitgutter'
Plug 'bfredl/nvim-ipy'
Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent' " change Python's indent to match PEP8
call plug#end()

" General configurations
set t_Co=256 " set terminal colors to 256
set number

" Lightline
let g:lightline = { 'colorscheme': 'wombat', }

" Color schemes
set background=dark
colorscheme Tomorrow-Night

" Custom key mappings
" autofill magic - make a M-q for Vim
nmap <space><space> gwip

" UltiSnip configuration
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Jedi configurations
autocmd FileType python setlocal completeopt-=preview " don't show docstrings

