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
    return
  endif

  execute 'edit' fnameescape(path)
enddef

export def Up()
  const parent_dir = fnamemodify(b:life_current_dir, ':h:h')
  const previous_folder = fnamemodify(b:life_current_dir, ':h:t')

  if parent_dir == '/'
    life#Open(parent_dir)
  else
    life#Open(parent_dir .. '/')
  endif

  const pattern = printf('\V\c\<%s\>', previous_folder)
  search(pattern, 'c')
enddef
