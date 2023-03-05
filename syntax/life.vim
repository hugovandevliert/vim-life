vim9script

if exists('b:current_syntax')
  finish
endif
b:current_syntax = 'life'

syntax match lifeDirectory =\%(\S\+ \)*\S\+/\ze\%(\s\{2,}\|$\)=
highlight default link lifeDirectory Directory
