vim9script noclear

if exists('g:loaded_life')
  finish
endif
const g:loaded_life = 1

augroup life
  autocmd!
  autocmd BufEnter * OnBufEnter()
  autocmd VimEnter * OnVimEnter()
augroup END

def OnBufEnter()
  const path = expand('%:p')
  if isdirectory(path)
    life#OpenDir(path)
  endif
enddef

def OnVimEnter()
  if exists('#FileExplorer')
    autocmd! FileExplorer
  endif
enddef
