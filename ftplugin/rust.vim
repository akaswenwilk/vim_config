set shiftwidth=8
set softtabstop=8
set expandtab
set list lcs=tab:\|\ 

let g:rustfmt_autosave = 1
let g:ale_rust_rls_executable = 'rust-analyzer'
let g:ale_fixers = {'rust': ['rustfmt']}
let g:ale_linters = {'rust': 'all'}

