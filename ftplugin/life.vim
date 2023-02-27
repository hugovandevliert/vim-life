vim9script

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = true

setlocal buftype=nofile
setlocal bufhidden=delete
setlocal nobuflisted
setlocal noswapfile

setlocal nowrap
setlocal nonumber
setlocal nospell

nnoremap <buffer> <Plug>(life-open) <Cmd>call life#Open()<CR>
nnoremap <buffer> <Plug>(life-open-split) <Cmd>call life#Open('split')<CR>
nnoremap <buffer> <Plug>(life-open-vertical-split) <Cmd>call life#Open('vsplit')<CR>
nnoremap <buffer> <Plug>(life-up) <Cmd>call life#Up()<CR>
nnoremap <buffer> <Plug>(life-create-file) <Cmd>call life#CreateFile()<CR>
nnoremap <buffer> <Plug>(life-create-dir) <Cmd>call life#CreateDir()<CR>
nnoremap <buffer> <Plug>(life-delete) <Cmd>call life#Delete()<CR>
nnoremap <buffer> <Plug>(life-reload) <Cmd>call life#Reload()<CR>
nnoremap <buffer> <Plug>(life-move) <Cmd>call life#Move()<CR>
nnoremap <buffer> <Plug>(life-copy) <Cmd>call life#Copy()<CR>
nnoremap <buffer> <Plug>(life-help) <Cmd>call life#Help()<CR>
nnoremap <buffer> <Plug>(life-toggle-info) <Cmd>call life#ToggleInfo()<CR>

nmap <buffer><nowait> <CR> <Plug>(life-open)
nmap <buffer><nowait> s <Plug>(life-open-split)
nmap <buffer><nowait> v <Plug>(life-open-vertical-split)
nmap <buffer><nowait> - <Plug>(life-up)
nmap <buffer><nowait> f <Plug>(life-create-file)
nmap <buffer><nowait> d <Plug>(life-create-dir)
nmap <buffer><nowait> D <Plug>(life-delete)
nmap <buffer><nowait> r <Plug>(life-reload)
nmap <buffer><nowait> R <Plug>(life-move)
nmap <buffer><nowait> C <Plug>(life-copy)
nmap <buffer><nowait> i <Plug>(life-toggle-info)
nmap <buffer><nowait> ? <Plug>(life-help)
