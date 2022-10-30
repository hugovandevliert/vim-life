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

export def Up()
  const parent_dir = fnamemodify(b:life_current_dir, ':h:h')

  if parent_dir == '/'
    life#Open(parent_dir)
  else
    life#Open(parent_dir .. '/')
  endif
enddef
