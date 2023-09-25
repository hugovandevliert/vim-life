vim9script

export def Init()
  var path = expand('%:p')
  if !isdirectory(path)
    return
  endif

  path = fnamemodify(path, ':h')
  if path != getcwd()
    path = fnamemodify(path, ':.')
  endif
  silent keepalt execute 'file' fnameescape(path)
  setlocal filetype=life
  ListDirectoryContents()
enddef

export def Open(cmd = 'edit')
  if CurrentItem() == ''
    return
  endif

  var path = CurrentDir() .. CurrentItem()
  if !isdirectory(path)
    path = fnamemodify(path, ':.')
  endif

  silent keepalt execute cmd fnameescape(path)
enddef

export def Up()
  const previous_folder = expand('%:t')
  silent keepalt edit %:h
  MoveCursor(previous_folder)
enddef

export def Reload()
  const filename = CurrentItem()
  ListDirectoryContents()
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
  ListDirectoryContents()
  MoveCursor(dirname)
enddef

export def Delete()
  if CurrentItem() == ''
    return
  endif

  const path = CurrentDir() .. CurrentItem()
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

  remove(b:life_directory_items, line('.') - 1)

  redraw!
  setlocal modifiable
  delete
  setlocal nomodifiable
enddef

export def Move()
  if CurrentItem() == ''
    return
  endif

  const path = CurrentDir() .. CurrentItem()
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
  ListDirectoryContents()
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Copy()
  if CurrentItem() == ''
    return
  endif

  const path = CurrentDir() .. CurrentItem()
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
  ListDirectoryContents()
  MoveCursor(fnamemodify(newpath, ':t'))
enddef

export def Help()
  redraw!
  echo 'Available commands:'
  echo 'o open selected file or directory'
  echo 's open selected file or directory in a split window'
  echo 'v open selected file or directory in a vertical split window'
  echo '- go up one directory'
  echo 'f open a new file'
  echo 'd create a directory'
  echo 'C copy selected file or directory'
  echo 'R rename/move selected file or directory'
  echo 'D delete selected file or directory'
  echo 'r reload directory listing'
  echo 'i toggle file info'
  echo '? show this message'
enddef

export def ToggleInfo()
  w:life_show_info = !get(w:, 'life_show_info', false)
  const current = CurrentItem()
  ListDirectoryContents()
  MoveCursor(current)
enddef

def ListDirectoryContents()
  b:life_directory_items = readdirex(CurrentDir(), '1', {sort: 'none'})->sort(CompareFile)

  var names: list<string>
  if get(w:, 'life_show_info', false)
    const offset = max(mapnew(b:life_directory_items, (_, file) => strchars(file.name))) + 10
    names = mapnew(b:life_directory_items, (_, file) => {
      const name = file.name .. (IsDir(file) ? '/' : '')
      const time = strftime('%x %X', file.time)
      const size = HumanReadableSize(file.size)
      return printf($"%-{offset}S %6S %20S", name, size, time)
    })
  else
    names = mapnew(b:life_directory_items, (_, file) => file.name .. (IsDir(file) ? '/' : ''))
  endif

  setlocal modifiable
  silent keepjumps :% delete _
  setline(1, names)
  setlocal nomodifiable
enddef

def MoveCursor(text: string)
  const pattern = printf('^%s\/\?\%(\s\{2,}\|$\)', fnameescape(text))
  search(pattern, 'c')
enddef

def HumanReadableSize(bytes: number): string
  if bytes == 0
    return ''
  endif

  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB']
  var size = bytes
  var i = 0

  while size >= 1024
    size = size / 1024
    i += 1
  endwhile

  return printf('%.0f %s', size, suffixes[i])
enddef

def CompareFile(f1: dict<any>, f2: dict<any>): number
  if IsDir(f1) != IsDir(f2)
    return IsDir(f1) ? -1 : +1
  endif

  return f1.name < f2.name ? -1 : +1
enddef

def IsDir(file: dict<any>): bool
  return file.type =~ 'dir\|linkd'
enddef

def CurrentItem(): string
  const item = b:life_directory_items->get(line('.') - 1, {name: '', type: ''})
  return item.name .. (IsDir(item) ? '/' : '')
enddef

def CurrentDir(): string
  return expand('%') .. '/'
enddef
