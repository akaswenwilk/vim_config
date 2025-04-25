" Settings {{{
set nocompatible

" In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set expandtab 

" Round indent to multiple of shiftwidth
set shiftround

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

set foldlevel=99

" make sure language is english
language en_US
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


"" allows search with motion
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

nnoremap <silent> t :call OpenLocInTab()<CR>
"
function! OpenLocInTab()
  if &l:buftype ==# 'quickfix' && getloclist(0, {'title': 0}).title != ''
        let line = getline('.')
        let matchlist = matchlist(line, '\v(.+)\|(\d+) col (\d+)\|')
        let file = matchlist[1]
        let lnum = matchlist[2]
        let col = matchlist[3]
        execute 'tabnew ' . fnameescape(file)
        execute lnum
        execute 'normal! ' . col . '|'
  else
        normal! t
  endif
endfunction


" for vimdiff mode
nnoremap <leader>1 :diffget LOCAL<CR>
nnoremap <leader>2 :diffget BASE<CR>
nnoremap <leader>3 :diffget REMOTE<CR>
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
" }}}



" Insert Mappings {{{
" allows changing windows with alt + movement key
inoremap <C-h> <Esc><c-w>h
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

cnoreabbrev ff call WriteFile()

function! WriteFile()
  redir @+>
  echo expand('%')
  redir END
endfunction

cnoreabbrev errcount call ListErrorCount()

function! ListErrorCount()
  echom ale#statusline#Count(bufnr('%'))
endfunction

" Function to diff two open buffers
function! DiffBuffers()
  if len(tabpagebuflist()) != 2
    echo "Exactly two buffers must be open in the current tab."
    return
  endif
  windo diffthis
endfunction

" Key binding to trigger the DiffBuffers function
cnoreabbrev diffbuff call DiffBuffers()<CR>
" }}}



" Autocmd Groups {{{

" sets autosave
augroup autosave
  autocmd!
  autocmd BufLeave,InsertLeave,CursorHold * call Update()
augroup END

function! Update()
  if &readonly == 0
    silent! update
  endif
endfunction

" autoread when changes on files from disk
set autoread
augroup autoread
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

"" }}}

" Declare the list of plugins.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'graywh/vim-colorindent'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'powerman/vim-plugin-AnsiEsc', { 'for': ['text'] }
Plug 'github/copilot.vim'
Plug 'hashivim/vim-terraform', { 'for': ['tf'] }
Plug 'rhysd/rust-doc.vim', { 'for': ['rust'] }
Plug 'junegunn/vim-easy-align'
Plug 'gurpreetatwal/vim-avro'
Plug 'Xuyuanp/nerdtree-git-plugin'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Plugin Settings {{{
colorscheme gruvbox

" enables fzf
set rtp+=/opt/homebrew/bin/fzf

let g:ale_completion_enabled = 1

set completeopt=menu,menuone,preview,noselect,noinsert

" coc-explorer
nnoremap <leader>er <Plug>(ale_next_wrap)
nnoremap <leader>nt :NERDTreeToggle<CR>
augroup autoopenexplorer
  autocmd!
  autocmd VimEnter * :if bufname()=='' | call execute('NERDTreeToggle') | endif
augroup END

" sets ack to use ripgrep
let g:ackprg = 'rg --vimgrep --smart-case -g "!{**/.git/*}" --hidden'

nnoremap <leader>d <Plug>(ale_go_to_definition)
nnoremap <leader>dv :vsplit<cr> <Plug>(ale_go_to_definition)
nnoremap <leader>t :vsplit<cr> <Plug>(ale_go_to_type_definition)
nnoremap <leader>i :vsplit<cr> <Plug>(go_to_implementation)
nnoremap <leader>r :ALEFindReferences -relative<cr>
nnoremap <leader>rn <Plug>(ale_rename)

" Use K to show documentation in preview window.
nnoremap <silent> K :<Plug>(ale_hover)<CR>

let g:ale_linters = {
        \ 'avdl': ['jsonlint'],
        \}

let NERDTreeShowHidden = 1

let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowClean = 0
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Deleted'   : '✖',
  \ 'Dirty'     : '✗',
  \ 'Ignored'   : '☒',
  \ 'Clean'     : '✔︎',
  \ 'Unknown'   : '?'
  \ }
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

" remap copilot completions
inoremap <C-j> <Plug>(copilot-next)
inoremap <C-k> <Plug>(copilot-previous)
" }}}

highlight ColorIndentEven ctermbg=8 guibg=#303030

" Map the function to a key combination, e.g., <C-u> (Ctrl+u)
inoremap <C-u> <C-o>:call InsertUUID()<CR>

function! InsertUUID()
  let l:uuid = tolower(system('uuidgen'))
  " Remove the trailing newline
  let l:uuid = substitute(l:uuid, '\n', '', '')
  " Insert the UUID
  execute 'normal! a' . l:uuid
endfunction
