vim9script

export def Init()
  const path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  setlocal filetype=life
  ListContents(path)
  silent keepalt execute 'file' fnameescape(fnamemodify(path, ':h'))
enddef

export def Open(cmd = 'edit')
  const path = CurrentDir() .. getline('.')

  silent keepalt execute cmd fnameescape(fnamemodify(path, ':.'))
enddef

export def Up()
  const previous_folder = expand('%:t')
  silent keepalt edit %:h
  MoveCursor(previous_folder)
enddef

export def Reload()
  const filename = getline('.')
  ListContents(CurrentDir())
  MoveCursor(filename)
enddef

export def CreateFile()
  const filename = input('Please enter a file name: ')
  if !filename
    return
  endif

  const path = CurrentDir() .. filename
  execute 'edit' fnameescape(fnamemodify(path, ':.'))
enddef

export def CreateDir()
  const dirname = input('Please enter a directory name: ')
  if !dirname
    return
  endif

  const path = CurrentDir() .. dirname
  const output = system('mkdir -p ' .. fnameescape(path))
  if v:shell_error != 0
    echoerr output
    return
  endif

  redraw!
  ListContents(CurrentDir())
  MoveCursor(dirname)
enddef

export def Delete()
  const path = CurrentDir() .. getline('.')
  echo 'Confirm deletion of' isdirectory(path) ? 'directory' : 'file' path '[Y/n]'
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
  const path = CurrentDir() .. getline('.')
  const newpath = input('Moving ' .. path .. ' to: ', isdirectory(path) ? fnamemodify(path, ':h') : path, 'file')

  if !newpath
    return
  endif

  const output = system('mv ' .. fnameescape(path) .. ' ' .. fnameescape(newpath))
  if v:shell_error != 0
    echoerr output
    return
  endif

  redraw!
  ListContents(CurrentDir())
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Copy()
  const path = CurrentDir() .. getline('.')
  const newpath = input('Copying ' .. path .. ' to: ', isdirectory(path) ? fnamemodify(path, ':h') : path, 'file')

  if !newpath
    return
  endif

  const output = system('cp -R ' .. fnameescape(path) .. ' ' .. fnameescape(newpath))
  if v:shell_error != 0
    echoerr output
    return
  endif

  redraw!
  ListContents(CurrentDir())
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Help()
  echo 'Available commands:'
  echo '<CR> open selected file or directory'
  echo ' s   open selected file or directory in a split window'
  echo ' v   open selected file or directory in a vertical split window'
  echo ' -   go up one directory'
  echo ' f   open a new file'
  echo ' d   create a directory'
  echo ' C   copy selected file or directory'
  echo ' R   move/rename selected file or directory'
  echo ' D   delete selected file or directory'
  echo ' r   reload directory listing'
  echo ' ?   show this message'
enddef

def ListContents(path: string)
  final entries = readdirex(path, '1', {sort: 'none'})
  sort(entries, Compare)
  const names = entries->mapnew((_, file) => file.name .. (IsDir(file) ? '/' : ''))

  setlocal modifiable
  silent keepjumps :% delete _
  setline(1, names)
  setlocal nomodifiable
enddef

def MoveCursor(text: string)
  const pattern = printf('\V\^%s\/\?\$', text)
  search(pattern, 'c')
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

def CurrentDir(): string
  return expand('%') .. '/'
enddef
