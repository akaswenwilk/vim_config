setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8

nnoremap <leader>i :GoImports<cr>
nnoremap <leader>f :GoTestFunc<cr>
nnoremap <leader>k :w<cr>:GoTest -v `expand('%:h')`<cr>

nnoremap <leader>b :call GetBreakPoint()<cr>

function! GetBreakPoint()
	exe "GoDebugBreakpoint"
	let @*="break ".expand('%').":".line(".")
endfunction

let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_textobj_enabled = 0
