setlocal foldmethod=syntax
set shiftwidth=8
set softtabstop=8
set expandtab

set listchars=tab:\|\ 
set list

nnoremap <leader>i :GoImports<cr>
nnoremap <leader>f :GoTestFunc<cr>

nnoremap <leader>k :w<cr>:GoTest -v `expand('%:h')`<cr>
