au BufNewFile,BufRead *.hcl set filetype=tf

au BufRead,BufNewFile *.tf setlocal filetype=tf

autocmd BufRead,BufNewFile *.avsc set filetype=avdl
