" if exists('b:did_ftplugin')
"   finish
" endif
" b:did_ftplugin = true

setlocal bufhidden=delete
setlocal buftype=nowrite
setlocal nomodifiable
setlocal noswapfile

setlocal nowrap
setlocal nonumber
setlocal nospell

nnoremap <buffer> <Plug>(life-open) <Cmd>call life#OpenFile()<CR>

nmap <buffer><nowait> <CR> <Plug>(life-open)
