vim9script

export def Open(path: string)
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

  b:life_current_dir = path
enddef

export def OpenFile()
  const path = b:life_current_dir .. getline('.')

  if isdirectory(path)
    life#Open(path)
  endif

  execute 'edit' fnameescape(path)
enddef
