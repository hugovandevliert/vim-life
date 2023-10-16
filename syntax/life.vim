vim9script

if exists('b:current_syntax')
  finish
endif
b:current_syntax = 'life'

syntax match lifeDirectory =\%(\S\+ \)*\S\+/\ze\%(\s\{2,}\|$\)=
syntax match lifeSymlink =\%(\S\+ \)*\S\+\ze\s-->=
syntax match lifeSymlinkArrow =\s-->\s=

highlight default link lifeDirectory Directory
highlight default link lifeSymlink Question
highlight default link lifeSymlinkArrow Title
