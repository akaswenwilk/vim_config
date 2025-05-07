"setlocal foldmethod=syntax
"set shiftwidth=2
"set softtabstop=2
"
"" easy mapping to format json file.  requires installation of jq
"nnoremap <leader>j :%!jq .<cr>
"
"cnoreabbrev sortjson %!jq -S .<cr>
