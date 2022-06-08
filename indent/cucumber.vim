" Vim indent file
" Language:	Cucumber
" Maintainer:	Tim Pope <vimNOSPAM@tpope.org>
" Last Change:	2017 Jun 13

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetCucumberIndent()
setlocal indentkeys=o,O,*<Return>,<:>,0<Bar>,0#,=,!^F

let b:undo_indent = 'setl ai< inde< indk<'

" Only define the function once.
if exists("*GetCucumberIndent")
  finish
endif

function! s:syn(lnum)
  return synIDattr(synID(a:lnum,1+indent(a:lnum),1),'name')
endfunction

function! GetCucumberIndent()
  let line  = getline(prevnonblank(v:lnum-1))
  let cline = getline(v:lnum)
  let nline = getline(nextnonblank(v:lnum+1))
  let sw = exists('*shiftwidth') ? shiftwidth() : shiftwidth()
  let syn = s:syn(prevnonblank(v:lnum-1))
  let csyn = s:syn(v:lnum)
  let nsyn = s:syn(nextnonblank(v:lnum+1))
  if csyn =~# '^cucumber\%(Examples\|Feature\|Background\|Scenario\|ScenarioOutline\)$' || cline =~# '^\s*\%(Feature\|Background\|Scenario\|Scenarios\|Scenario Outline\):'
    " background, scenario or outline heading
    return 0
  elseif syn =~# '^cucumber\%(Feature\|Examples|\Background\|Scenario\|ScenarioOutline\)$' || line =~# '^\s*\%(Feature\|Examples\|Scenarios\|Background\|Scenario\|Scenario Outline\):'
    " line after background, scenario or outline heading
    return sw
  elseif cline =~# '^\s*@'
    " tags
    " preserve indent of next line
    return indent(nextnonblank(v:lnum+1))
  elseif cline =~# '^\s*|'
    " mid-table
    " preserve indent related to example
    return sw
  elseif cline =~# '^\s*#'
    " comment
    " preserve indent of next line it's commenting
    return indent(nextnonblank(v:lnum+1))
  elseif line =~# '^.*\({\|[\)$'
    " start of json
    return indent(prevnonblank(v:lnum-1)) + sw
  elseif cline =~# '^\s*\(}\|]\)'
    " end of json
    return indent(prevnonblank(v:lnum-1)) - sw
  elseif cline =~# '^\s*\(Given\|When\|Then\|And\)'
    " steps
    return sw
  endif
  return indent(prevnonblank(v:lnum-1))
endfunction

" vim:set sts=2 sw=2:
