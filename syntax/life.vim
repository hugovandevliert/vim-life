vim9script

if exists('b:current_syntax')
  finish
endif
b:current_syntax = 'life'

syntax match lifeDirectory =^.\+/$=
highlight default link lifeDirectory Directory
