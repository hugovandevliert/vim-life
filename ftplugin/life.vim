vim9script

setlocal bufhidden=delete
setlocal buftype=nowrite
setlocal nomodifiable
setlocal noswapfile

setlocal nowrap
setlocal nonumber
setlocal nospell

nnoremap <buffer> <Plug>(life-open) <Cmd>call life#Open()<CR>
nnoremap <buffer> <Plug>(life-up) <Cmd>call life#Up()<CR>
nnoremap <buffer> <Plug>(life-create-file) <Cmd>call life#CreateFile()<CR>
nnoremap <buffer> <Plug>(life-create-dir) <Cmd>call life#CreateDir()<CR>

nmap <buffer><nowait> <CR> <Plug>(life-open)
nmap <buffer><nowait> - <Plug>(life-up)
nmap <buffer><nowait> f <Plug>(life-create-file)
nmap <buffer><nowait> d <Plug>(life-create-dir)
