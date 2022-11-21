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
  if exists('b:life_initialized')
    return
  endif
  b:life_initialized = true
  life#Init()
enddef

def OnVimEnter()
  if exists('#FileExplorer')
    autocmd! FileExplorer
  endif
enddef
