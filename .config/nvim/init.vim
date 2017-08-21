" -| Plugins |-
call plug#begin('~/.nvim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'tmhedberg/matchit'
Plug 'mbbill/undotree'
Plug 'tpope/vim-vinegar'
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Some themes
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
"Plug 'altercation/vim-colors-solarized'
Plug 'airblade/vim-gitgutter'
Plug 'klen/python-mode'
"Plug 'scrooloose/syntastic'
"Plug 'hynek/vim-python-pep8-indent' " change Python's indent to match PEP8
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
"Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'Shutnik/jshint2.vim'
Plug 'marijnh/tern_for_vim'
Plug 'rking/ag.vim'
Plug 'ivanov/vim-ipython'
Plug 'tpope/vim-rsi'        " emacs-like insert mode movements
Plug 'tpope/vim-surround'   " faster edits for surrounding whatever
Plug 'tpope/vim-commentary' " faster commenting code, e.g. gcc to comment line
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired' " faster navigation for quickfix items
Plug 'tpope/vim-repeat'
Plug 'keith/investigate.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mattn/gist-vim'
Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
call plug#end()

filetype plugin indent on

" -| Color schemes |- 
colorscheme tomorrow-night-eighties

" -| nvim-R |-
let R_vsplit=1
iabb <buffer> _ <-
let R_rmd_environment = "new.env()"

" -| Cursor |- 
let NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" -| General configurations |-
set t_Co=256 " set terminal colors to 256
set number
" edit $MYVIMRC with space e v 
let mapleader = " "
let maplocalleader = " "
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
set smartcase
set hidden " allow hidden buffers
set autochdir " automatically change the current directory to cd
let g:quickfix_min_height = 2
let g:quickfix_max_height = 8
autocmd FileType help wincmd L " open help in vsplit
set shortmess+=IA " don't open a message when Vim starts
" don't show that incredibly annoying doc window during ocompletion
set completeopt-=preview


" -| Spell checking |-
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell/'
setlocal spelllang=en_us
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=Red
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd BufRead,BufNewFile *.Rmd setlocal spell
" see the bottom for iabbrevs

" -| Indentation |-
set expandtab
set shiftwidth=2
set softtabstop=2
set smartindent
" Python-specific indentation
autocmd FileType python set expandtab shiftwidth=4 softtabstop=4 

" -| Nerdtree |-
" let g:NERDTreeIndicatorMap = {
"             \ "Modified"  : "☀",
"             \ "Staged"    : "+",
"             \ "Untracked" : " ",
"             \ "Renamed"   : "r",
"             \ "Unmerged"  : "═",
"             \ "Deleted"   : "d",
"             \ "Dirty"     : "✗",
"             \ "Clean"     : "✓",
"             \ "Unknown"   : "?"
"             \ }

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

" -| investigate |-
nnoremap <leader>i :call investigate#Investigate()<CR>

" -| syntastic |-
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

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
nnoremap <leader>pc :PlugClean<cr>
nnoremap <leader>a :Ag<space>
nnoremap <leader>q :ccl<cr>
nnoremap <leader>h :noh<cr>
nnoremap <leader>o :CtrlP<cr>
nnoremap <leader>e :e 
nnoremap <leader>w :w<cr>
nnoremap <leader>u :UndotreeToggle<cr>
" delete a buffer without closing a split
nnoremap <leader>bd :bp\|bd#<cr>

" -| More custom key mappings |-
"  some tasty hacks from:
"  http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" -| Ctrl-P |-
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*.pdf,*.docx,*.jpg,*.png,*.jpeg,*.pptx,*.mp3
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.bbl,*.blg,*.fls,*.bcf,*.out,*.log,*.aux,*.dYSM

" -| UltiSnip configuration |- 
let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips/"
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" -| Pymode settings |- 
" pymode's completion sucks compared to YouCompleteMe; turn it off
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_lint_on_write = 1
let g:pymode_folding = 0
"let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_checkers = ['pyflakes']
let g:pyflakes_use_quickfix = 0
let g:pymode_quickfix_maxheight = g:quickfix_max_height
let g:pymode_quickfix_minheight = g:quickfix_min_height

" - | YouCompleteMe settings |-
" find the definition/declaration, bring me there, and give me some breathing
" room
nnoremap <leader>j :YcmCompleter GoTo<cr>zt<c-y>

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
let g:tex_flavor='latex'
let g:vimtex_fold_envs = 0
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'


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

" |- abbreviations
" words I may someday learn to type correctly
iabbrev meosises meioses

" |- LaTeX comment hacks
function! FindLaTeXComments()
  highlight CommentGC ctermfg=red
  highlight CommentVB ctermfg=blue
  call matchadd('CommentGC', '\\gc{\_[^}]*}')
  call matchadd('CommentVB', '\\vb{\_[^}]*}')
endfunction

command! GC call FindLaTeXComments()
nnoremap <leader>gc :GC<cr>

