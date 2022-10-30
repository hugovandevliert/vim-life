vim9script

setlocal bufhidden=delete
setlocal buftype=nowrite
setlocal nomodifiable
setlocal noswapfile

setlocal nowrap
setlocal nonumber
setlocal nospell

nnoremap <buffer> <Plug>(life-open) <Cmd>call life#OpenFile()<CR>
nnoremap <buffer> <Plug>(life-up) <Cmd>call life#Up()<CR>

nmap <buffer><nowait> <CR> <Plug>(life-open)
nmap <buffer><nowait> - <Plug>(life-up)
