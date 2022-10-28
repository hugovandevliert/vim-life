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
