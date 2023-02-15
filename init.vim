" Settings {{{
set nocompatible

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set expandtab 

" default shift amount
set shiftwidth=2
set softtabstop=2

" Round indent to multiple of shiftwidth
set shiftround

" re-reads file if changes occurred on disk while open in buffer
set autoread

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Enable use of the mouse for all modes
set mouse=a

" Display line numbers on the left
set number relativenumber

" Use visual bell instead of beeping when doing something wrong
set visualbell

" indents wrapped text
set breakindent

" decreases time it takes for cursor hold event to fire for autosave
set updatetime=500

" disable swap files
set noswapfile

" sets splits to be default to bottom or to right
set splitbelow
set splitright

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on

" enable syntax
syntax enable

" highlights searched term
set hlsearch

" auto jumps to first match for search
set incsearch

" sets <space> to leader key
let mapleader = "\<Space>"

" autoread when changes on files from disk
set autoread
" }}}



" Plugin Settings {{{
let g:coc_global_extensions = ['coc-solargraph', 'coc-go', 'coc-rust-analyzer', 'coc-snippets']
colorscheme gruvbox

" enables fzf
set rtp+=/opt/homebrew/bin/fzf

" make hidden files showed by default in nerdtree
let NERDTreeShowHidden=1

" sets ack to use ripgrep
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
" }}}



" Plugin Mappings {{{
" global text search
nnoremap <leader>g :set operatorfunc=<SID>AckOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>AckOperator(visualmode())<cr>
nnoremap <leader>F :call AckOperatorFullTextSearch("", ".")<Left><Left><Left><Left><Left><Left><Left>

function! s:AckOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  call AckOperatorFullTextSearch(@@, ".")

  let @@ = saved_unnamed_register
endfunction

function! g:AckOperatorFullTextSearch(value, directories)
  silent execute "Ack! " . shellescape(a:value) . " " . shellescape(a:directories)
  call matchadd('Search', a:value)
endfunction

function! s:AckOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "Ack! " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction

" ctrl-p for fzf
nnoremap <C-p> :FZF<cr>

" toggle explore
nnoremap <leader>nt :NERDTreeToggle<cr>

" go to definition
nmap <leader>d <Plug>(coc-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>t <Plug>(coc-type-definition)
nmap <leader>r <Plug>(coc-references-used)
" Show hover when provider exists, fallback to vim's builtin behavior.
nnoremap K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  call CocActionAsync('definitionHover')
endfunction

" use tab to navigate autocompletions
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

nmap <leader>fs <Plug>(coc-codeaction-refactor)
" }}}



" Normal mappings {{{

" use ev to open split of vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" use sv to source latest vimrc changes
nnoremap <leader>sv :source $MYVIMRC<cr>


" sets a search to always be in regex mode
nnoremap / /\v

" sets hl to stop highlight from last search
nnoremap <leader>hl :call DeleteSearchMatches()<cr>:noh<cr>
function! DeleteSearchMatches()
  let matches = getmatches()

  for i in matches
    if i['group'] ==# 'Search'
      call matchdelete(i['id'])
    endif
  endfor
endfunction


" allows search with motion
nnoremap <leader>/ :set operatorfunc=<SID>SearchOperator<cr>g@
vnoremap <leader>/ :<c-u>call <SID>SearchOperator(visualmode())<cr>

function! s:SearchOperator(type)
  let saved_anonymous_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  call DeleteSearchMatches()

  let @/ = @@
  call matchadd('search', @/)

  let @@ = saved_anonymous_register
endfunction

" sets tn to next tab
nnoremap <leader>tn :tabn<cr>

" sets tp to previous tab
nnoremap <leader>tp :tabp<cr>

" closes tab with q
nnoremap <leader>q :q!<cr>

" allows changing windows with ctrl key
nnoremap <C-h> <c-w>h
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

" easy window resize
nnoremap <leader><up> :resize +5<cr>
nnoremap <leader><down> :resize -5<cr>
nnoremap <leader><left> :vertical resize -5<cr>
nnoremap <leader><right> :vertical resize +5<cr>

" for vimdiff mode
if &diff
    nnoremap <leader>1 :diffget LOCAL<CR>
    nnoremap <leader>2 :diffget BASE<CR>
    nnoremap <leader>3 :diffget REMOTE<CR>
endif

" delete whitespaces
nnoremap <leader>s :%s/\s\+$//e<CR>
" }}}



" Visual Mappings {{{
" allows copying text to system clipboard with control-c -
" linux needs dependency installed, but mac uses something else
" sudo apt-get update && sudo apt-get install vim-gtk

vnoremap <C-c> :<C-u>call CopyToClipboard()<cr>

function! CopyToClipboard()
  normal! `<v`>"+y
endfunction

nnoremap <leader>p "+p

" easy mapping to format json file.  requires installation of jq
nnoremap <leader>j :%!jq .<cr>
" }}}



" Insert Mappings {{{
" allows changing windows with alt + movement key
inoremap <C-h> <Esc><c-w>h
inoremap <C-j> <Esc><c-w>j
inoremap <C-k> <Esc><c-w>k
inoremap <C-l> <Esc><c-w>l
" }}}



" Command Mappings {{{
cnoreabbrev gp call PushBranch()
cnoreabbrev ggfl call ForcePushBranch()
cnoreabbrev gup Git pull --rebase

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! PushBranch()
  let branch = GitBranch()
  execute "Git push -u origin " . branch
endfunction

function! ForcePushBranch()
  let branch = GitBranch()
  execute "Git push --force -u origin " . branch
endfunction

cnoreabbrev space call WritePWD()

function! WritePWD()
  redir @+>
  pwd
  redir END
endfunction
" }}}



" Autocmd Groups {{{

" sets folding for vim files
augroup autosave
  autocmd!
  autocmd VimLeavePre,FocusLost,CursorHold,CursorHoldI,WinLeave,TabLeave,InsertLeave,BufDelete,BufWinLeave * call AutoSave()
augroup END

function! AutoSave()
  if &buftype !=# 'terminal' && &buftype != "nofile"
    if &modified
      call CocAction('organizeImport')
      :w
    endif
  endif
endfunction

augroup quickfixOpen
  autocmd!
  autocmd FileType qf nnoremap <buffer> t <C-W><Enter><C-W>T
  autocmd FileType qf nnoremap <buffer> s <C-W><Enter><C-W>L
augroup END
" }}}
