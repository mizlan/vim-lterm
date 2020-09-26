# vim-lterm

A wrapper around the Neovim terminal window, with functionality for toggling and auto-compiling and running code.

Set preferred direction:

```vim
" vnew or new, depending on preferred opening side

let g:lterm_direction_cmd = 'vnew'
```

Set the shell to PowerShell in windows along with some additional necessary options:

```vim
" init.vim

set shell=powershell
set shellcmdflag=-c
set shellquote=\"
set shellxquote=
```
