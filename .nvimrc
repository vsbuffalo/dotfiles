" -| Plugins |-
call plug#begin('~/.nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Some themes
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
"Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'klen/python-mode'
"Plug 'hynek/vim-python-pep8-indent' " change Python's indent to match PEP8
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
"Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'othree/html5.vim'
Plug 'rking/ag.vim'
Plug 'ivanov/vim-ipython'
Plug 'tpope/vim-rsi'        " emacs-like insert mode movements
Plug 'tpope/vim-surround'   " faster edits for surrounding whatever
Plug 'tpope/vim-commentary' " faster commenting code, e.g. gcc to comment line
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired' " faster navigation for quickfix items

Plug 'terryma/vim-multiple-cursors'
call plug#end()

" -| Color schemes |- 
colorscheme tomorrow-night-eighties

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
let g:quickfix_min_height = 2
let g:quickfix_max_height = 8

" -| Indentation |-
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent
" Python-specific indentation
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4 

" -| Nerdtree |-
let g:NERDTreeIndicatorMap = {
            \ "Modified"  : "☀",
            \ "Staged"    : "+",
            \ "Untracked" : " ",
            \ "Renamed"   : "r",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "d",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✓",
            \ "Unknown"   : "?"
            \ }

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
      \   'readonly': '%{&readonly?"⦰":""}',
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

" -| Custom key mappings |- 
" autofill magic - make a M-q for Vim
nmap <space><space> gwip
nnoremap <leader>pi :PlugInstall<cr>
nnoremap <leader>a :Ag
nnoremap <leader>q :ccl
nnoremap <leader>h :noh<cr>

" -| UltiSnip configuration |- 
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" -| Pymode settings |- 
" pymode's completion sucks compared to YouCompleteMe; turn it off
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_lint_on_write = 1
let g:pymode_folding = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_quickfix_maxheight = g:quickfix_max_height
let g:pymode_quickfix_minheight = g:quickfix_min_height

" -| Sending code to terminal (experimental)  |- 
augroup Terminal
  au!
  au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
augroup END

function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction

command! REPLSendLine call REPLSend([getline('.')])
command! REPLSendLines call REPLSend(getline("'<", "'>"))

nnoremap <c-l> :REPLSendLine<cr>
inoremap <c-l> <c-o>:REPLSendLine<cr>
vnoremap <c-l> :<c-u>REPLSendLines<cr>

" -| latex |-
let g:vimtex_fold_envs = 0

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
      \ ]

" -| Todo items as a quickfix |-
function! TodoHelper(...)
  let a:query = "(TODO|FIXME|XXX)"
  let a:file = "*"
  if a:0 > 0
    let a:file = a:1
  endif
  let a:ag_todo_cmd = "Ag '" . a:query . "' --vimgrep --silent --nogroup --nocolor " . a:file
  execute a:ag_todo_cmd
endfunction

command! TodoBuffer call TodoHelper(bufname("%"))
command! TodoAll call TodoHelper()

nnoremap <leader>td :TodoBuffer<cr>
nnoremap <leader>ta :TodoAll<cr>

" adjust quickfix window height
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
au FileType qf call AdjustWindowHeight(g:quickfix_min_height, g:quickfix_max_height)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
