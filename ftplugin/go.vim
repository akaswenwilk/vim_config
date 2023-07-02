setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8

let g:go_gopls_gofumpt = v:true

nmap <leader>f <Plug>(go-test-func)
nmap <leader>fs <Plug>(go-fill-struct)

nnoremap <leader>b :call GetBreakPoint()<cr>

function! GetBreakPoint()
	let @*="break ".expand('%').":".line(".")
endfunction

let g:go_fmt_fail_silently = 1
