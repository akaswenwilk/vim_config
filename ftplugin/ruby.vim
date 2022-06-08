setlocal foldmethod=expr
setlocal foldexpr=GetRubyFold(v:lnum)

function! GetRubyFold(lnum)
  if getline(a:lnum) =~? '\v^\s*def\s'
    return "a1"
  endif

  if getline(a:lnum) =~? '\v^\s*if\s'
    return "a1"
  endif

  if getline(a:lnum) =~? '\v^\s*unless\s'
    return "a1"
  endif

  if getline(a:lnum) =~? '\v\sdo(\s*$|\s+\|)'
    return "a1"
  endif

  if getline(a:lnum) =~? '\v^\s*end\s*$'
    return "s1"
  endif

  return "="
endfunction

" ALE Settings
" Specify ruby linters, you'll likely want others enabled
let g:ale_linters = {'ruby': ['solargraph', 'rubocop']}

" Set the executable for ALE to call to get Solargraph
" up and running in a given session
let g:ale_ruby_solargraph_executable = 'solargraph'
let g:ale_ruby_solargraph_options = {}

let g:ale_completion_enabled = 1

" Fixes the bug identified in this issue:
" https://github.com/w0rp/ale/issues/1700
set completeopt=menu,menuone,preview,noselect,noinsert
