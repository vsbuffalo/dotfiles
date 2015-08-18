" -| Plugins |-
call plug#begin('~/.nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'airblade/vim-gitgutter'
"Plug 'bfredl/nvim-ipy'
Plug 'klen/python-mode'
"Plug 'hynek/vim-python-pep8-indent' " change Python's indent to match PEP8
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'othree/html5.vim'
Plug 'tpope/vim-rsi'        " emacs-like insert mode movements
Plug 'tpope/vim-surround'   " faster edits for surrounding whatever
Plug 'tpope/vim-commentary' " faster commenting code, e.g. gcc to comment line
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired' " faster navigation for quickfix items
call plug#end()

" -| General configurations |-
set t_Co=256 " set terminal colors to 256
set number
" edit $MYVIMRC with space e v 
nnoremap <space>ev :vsplit $MYVIMRC<cr>
nnoremap <space>sv :source $MYVIMRC<cr>
let mapleader = '\'
set smartcase
set hidden " allow hidden buffers
set autochdir " automatically change the current directory to cd

" -| Indentation |-
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent
" Python-specific indentation
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4 

" -| Better buffer switching |-
nnoremap <C-k> :bnext<CR>
nnoremap <C-j> :bprevious<CR>

" -| Terminal settings |-
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

" -| Lightline |- 
augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC 
augroup END
let g:lightline = { 'colorscheme': 'wombat', 
      \ 'active': { 
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive'], ['readonly', 'filename', 'modified'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"ro":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   },
      \ 'component_visible_condition': {
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \   }
      \ }

function! LightLineFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⎇ '._ : ''
  endif
  return ''
endfunction

" -| Color schemes |- 
set background=dark
colorscheme Tomorrow-Night
"let g:solarized_termcolors=256
"colorscheme solarized

" -| Custom key mappings |- 
" autofill magic - make a M-q for Vim
nmap <space><space> gwip

" -| UltiSnip configuration |- 
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" -| Pymode settings |- 
let g:pymode_folding = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8']

" -| Sending code to terminal (experimental)  |- 
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





