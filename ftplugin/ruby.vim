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
