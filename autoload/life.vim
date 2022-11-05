vim9script

export def OpenDir(path: string)
  final entries = readdirex(path, '1', { sort: 'none' })
  sort(entries, Compare)
  const names = entries->mapnew((_, file) => file.name .. (IsDir(file) ? '/' : ''))

  enew
  setline(1, names)
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

export def Reload()
  const filename = getline('.')

  life#OpenDir(b:life_current_dir)
  redraw!

  const pattern = printf('\V\^%s\$', filename)
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

export def Delete()
  const path = b:life_current_dir .. getline('.')
  echo 'Confirm deletion of' isdirectory(path) ? 'directory' : 'file' fnameescape(path) '[Y/n]'
  const c = getchar()

  if c != 13 && c != 121 # Y or <CR>
    redraw!
    return
  endif

  const output = system('rm -rf ' .. fnameescape(path))
  if v:shell_error != 0
    echoerr output
    return
  endif

  redraw!
  setlocal modifiable
  delete
  setlocal nomodifiable
enddef

def Compare(f1: dict<any>, f2: dict<any>): number
  if IsDir(f1) != IsDir(f2)
    return IsDir(f1) ? -1 : +1
  endif

  return f1.name < f2.name ? -1 : +1
enddef

def IsDir(file: dict<any>): bool
  return file.type =~ 'dir\|linkd'
enddef
