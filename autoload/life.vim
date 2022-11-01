vim9script

export def OpenDir(path: string)
  const files = readdirex(path)->mapnew((_, file) =>
    file.name .. (file.type =~ 'dir\|linkd' ? '/' : '')
  )

  # TODO: sorting

  enew

  setlocal modifiable

  setline(1, files)

  setlocal nomodifiable
  setlocal filetype=life

  b:life_current_dir = path
enddef

export def Open()
  const path = b:life_current_dir .. getline('.')

  if isdirectory(path)
    life#OpenDir(path)
    return
  endif

  execute 'edit' fnameescape(path)
enddef

export def Up()
  const parent_dir = fnamemodify(b:life_current_dir, ':h:h')
  const previous_folder = fnamemodify(b:life_current_dir, ':h:t')

  if parent_dir == '/'
    life#OpenDir(parent_dir)
  else
    life#OpenDir(parent_dir .. '/')
  endif

  const pattern = printf('\V\c\<%s\>', previous_folder)
  search(pattern, 'c')
enddef

export def CreateFile()
  const filename = input('Please enter a file name: ')
  const path = b:life_current_dir .. filename

  execute 'edit' fnameescape(path)
enddef

export def CreateDir()
  const dirname = input('Please enter a directory name: ')
  const path = b:life_current_dir .. dirname

  redraw! # get rid of input message

  const output = system('mkdir -p ' .. fnameescape(path))
  if v:shell_error != 0
    echoerr output
    return
  endif

  life#OpenDir(b:life_current_dir)

  const pattern = printf('\V\c\<%s\>', dirname)
  search(pattern, 'c')
enddef
