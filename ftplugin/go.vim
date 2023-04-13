setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8

let g:go_gopls_gofumpt = v:true

nmap <leader>i <Plug>(go-imports)
nmap <leader>f <Plug>(go-test-func)
nmap K <Plug>(go-doc)
nmap <leader>d <Plug>(go-def-vertical)
nmap <leader>t <Plug>(go-def-type-vertical)
nmap <leader>rn <Plug>(go-rename)
nmap <leader>r <Plug>(go-referrers)
nmap <leader>fs <Plug>(go-fill-struct)

nnoremap <leader>b :call GetBreakPoint()<cr>

function! GetBreakPoint()
	let @*="break ".expand('%').":".line(".")
endfunction
