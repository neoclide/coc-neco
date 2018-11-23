if exists('did_coc_neco_loaded') | finish | endif
let did_coc_neco_loaded = 1

let s:folder = expand('<sfile>:h:h')

call coc#util#regist_extension(s:folder)
