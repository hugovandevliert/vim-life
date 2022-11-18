vim9script

export def OpenDir(path: string)
  final entries = readdirex(path, '1', { sort: 'none' })
  sort(entries, Compare)
  const names = entries->mapnew((_, file) => file.name .. (IsDir(file) ? '/' : ''))

  if &filetype == 'life'
    setlocal modifiable
    silent keepjumps :% delete _
  else
    keepjumps keepalt buffer
    execute 'silent keepalt file' fnameescape(fnamemodify(path, ':h'))
    setlocal filetype=life
  endif

  setline(1, names)
  setlocal nomodifiable

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

  MoveCursor(previous_folder)
enddef

export def Reload()
  const filename = getline('.')

  life#OpenDir(b:life_current_dir)
  redraw!

  MoveCursor(filename)
enddef

export def CreateFile()
  const filename = input('Please enter a file name: ')
  if !filename
    return
  endif

  const path = b:life_current_dir .. filename
  execute 'edit' fnameescape(path)
enddef

export def CreateDir()
  const dirname = input('Please enter a directory name: ')
  if !dirname
    return
  endif

  const path = b:life_current_dir .. dirname
  const output = system('mkdir -p ' .. fnameescape(path))
  if v:shell_error != 0
    echoerr output
    return
  endif

  life#OpenDir(b:life_current_dir)
  redraw!
  MoveCursor(dirname)
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

export def Move()
  const path = b:life_current_dir .. getline('.')
  const newpath = input('Moving ' .. path .. ' to: ', isdirectory(path) ? fnamemodify(path, ':h') : path, 'file')

  if !newpath
    return
  endif

  const output = system('mv ' .. fnameescape(path) .. ' ' .. fnameescape(newpath))
  if v:shell_error != 0
    echoerr output
    return
  endif

  life#OpenDir(b:life_current_dir)
  redraw!
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Copy()
  const path = b:life_current_dir .. getline('.')
  const newpath = input('Copying ' .. path .. ' to: ', isdirectory(path) ? fnamemodify(path, ':h') : path, 'file')

  if !newpath
    return
  endif

  const output = system('cp -R ' .. fnameescape(path) .. ' ' .. fnameescape(newpath))
  if v:shell_error != 0
    echoerr output
    return
  endif

  life#OpenDir(b:life_current_dir)
  redraw!
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Help()
  echo 'Available commands:'
  echo '<cr> open selected file or directory'
  echo ' -   go up one directory'
  echo ' f   open a new file'
  echo ' d   create a directory'
  echo ' C   copy selected file or directory'
  echo ' R   move/rename selected file or directory'
  echo ' D   delete selected file or directory'
  echo ' r   reload directory listing'
  echo ' ?   show this message'
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

def MoveCursor(text: string)
  const pattern = printf('\V\^%s\/\?\$', text)
  search(pattern, 'c')
enddef
