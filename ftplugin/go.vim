setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8

nnoremap <leader>i :call CocAction('organizeImport')<cr>

nnoremap <leader>b :call GetBreakPoint()<cr>

function! GetBreakPoint()
	let @*="break ".expand('%').":".line(".")
endfunction
