setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8

let g:go_gopls_gofumpt = v:true

nnoremap <leader>f <Plug>(go-test-func)
nnoremap <leader>fs <Plug>(go-fill-struct)
nnoremap <leader>d <Plug>(go-def)
nnoremap <leader>dv <Plug>(go-def-vertical)
nnoremap <leader>t <Plug>(go-def-type-vertical)
nnoremap <leader>i <Plug>(go-implements)
nnoremap <leader>r <Plug>(go-referrers)
nnoremap <leader>k <Plug>(go-doc-browser)
nnoremap <leader>rn <Plug>(go-rename)

nnoremap <leader>b :call GetBreakPoint()<cr>

function! GetBreakPoint()
        let @*="break ".expand('%').":".line(".")
endfunction

let g:go_fmt_fail_silently = 1

let g:go_build_tags = "integration,functional"

let g:ale_go_gopls_options = '--remote=auto'
let g:ale_go_gopls_init_options = {'buildFlags': ['-tags', 'integration,functional']}

