setlocal foldmethod=expr
setlocal foldexpr=MarkdownFold()

function! MarkdownFold()
    let l:line = getline(v:lnum)
    if empty(l:line)
        return '='
    elseif l:line =~ '^#'
        return '>' . len(matchstr(l:line, '^#*'))
    endif
    return '='
endfunction
