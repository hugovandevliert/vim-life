vim9script

export def Open(path = getcwd())
  # TODO: support linked directories
  final files = readdirex(path)->mapnew((_, file) =>
    file.name .. (file.type == 'dir' ? '/' : '')
  )

  # TODO: sorting

  enew

  setlocal modifiable

  setline(1, files)

  setlocal nomodifiable
  setlocal filetype=life
enddef

export def OpenFile()
  # TODO: expand('%:p') won't do it, it's not updated when in nested folders. We
  # might have to store the current directory somewhere.
  const path = expand('%:p') .. getline('.')

  if isdirectory(path)
    life#Open(path)
  endif

  execute 'edit' fnameescape(path)
enddef
