" Settings {{{

let g:coc_global_extensions = ['coc-solargraph', 'coc-go']

set nocompatible

" re-reads file if changes occurred on disk while open in buffer
set autoread

colorscheme gruvbox

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

" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on

" highlights searched term
set hlsearch

" auto jumps to first match for search
set incsearch

" sets <space> to leader key
let mapleader = "\<Space>"

" enables fzf
set rtp+=/opt/homebrew/bin/fzf

" autoread when changes on files from disk
set autoread

" make hidden files showed by default in nerdtree
let NERDTreeShowHidden=1

" }}}

" Normal mappings {{{

" sets a search to always be in regex mode
nnoremap / /\v

" sets hl to stop highlight from last search
nnoremap <leader>hl :call DeleteSearchMatches()<cr>:noh<cr>

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

function! DeleteSearchMatches()
  let matches = getmatches()

  for i in matches
    if i['group'] ==# 'Search'
      call matchdelete(i['id'])
    endif
  endfor
endfunction

" global text search
nnoremap <leader>g :set operatorfunc=<SID>AckOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>AckOperator(visualmode())<cr>

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

let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

nnoremap <leader>g :set operatorfunc=<SID>AckOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>AckOperator(visualmode())<cr>
nnoremap <leader>F :call AckOperatorFullTextSearch("", ".")<Left><Left><Left><Left><Left><Left><Left>

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

" ctrl-p for fzf
nnoremap <C-p> :FZF<cr>

" toggle explore
nnoremap <leader>nt :NERDTreeToggle<cr>

" go to definition
nnoremap <leader>d :vsp<cr>:call CocActionAsync('jumpDefinition')<cr>
nnoremap <leader>t :ALEGoToTypeDefinition -vsplit<cr>
nnoremap <leader>r :vsp<cr><Plug>(coc-references-used)

" show hover info
nnoremap <leader>h :ALEHover<cr>

" for vimdiff mode
if &diff
    nnoremap <leader>1 :diffget LOCAL<CR>
    nnoremap <leader>2 :diffget BASE<CR>
    nnoremap <leader>3 :diffget REMOTE<CR>
endif
" }}}

" delete whitespaces
nnoremap <leader>s :%s/\s\+$//e<CR>

" Visual Mappings {{{

" allows copying text to system clipboard with control-c -
" linux needs dependency installed, but mac uses something else
" sudo apt-get update && sudo apt-get install vim-gtk

vnoremap <C-c> :<C-u>call CopyToClipboard()<cr>

function! CopyToClipboard()
  normal! `<v`>"+y
endfunction

nnoremap <leader>p "+p

" easy mapping to format json file
nnoremap <leader>j :%!jq .<cr>

" }}}

" Insert Mappings {{{
" allows changing windows with alt + movement key
inoremap <C-h> <Esc><c-w>h
inoremap <C-j> <Esc><c-w>j
inoremap <C-k> <Esc><c-w>k
inoremap <C-l> <Esc><c-w>l
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
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
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup autosave
  autocmd!
  autocmd VimLeavePre,FocusLost,CursorHold,CursorHoldI,WinLeave,TabLeave,InsertLeave,BufDelete,BufWinLeave * call AutoSave()
augroup END

function! AutoSave()
  if &buftype !=# 'terminal' && &buftype != "nofile"
    if &modified
      :w
    endif
  endif
endfunction

augroup autoload
  autocmd!
  autocmd VimLeavePre,FocusLost,CursorHold,CursorHoldI,WinLeave,TabLeave,InsertLeave,BufDelete,BufWinLeave * if mode() != 'c' | checktime | endif
augroup END

" }}}

