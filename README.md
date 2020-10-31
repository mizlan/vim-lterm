<h1 align="center">ATTENTION! DEPRECATED! Use <a href='https://github.com/mizlan/termbufm'>termbufm</a></h1>

# vim-lterm

A wrapper around the Neovim terminal window, with functionality for toggling and auto-compiling and running code.

Set preferred direction:

```vim
" vnew or new, depending on preferred opening side

let g:lterm_direction_cmd = 'vnew'
```

Load default keymaps:

```vim
" init.vim

" load the keymaps for build/run
" default keymaps:
" <leader>lb to build
" <leader>lr to run
" <leader>lt to toggle window
call lterm#load_keymaps()

" load 'sensible' keymaps (<Esc> for terminal)
call lterm#load_terminal_keymaps()
```

Edit language configurations:
Add languages to the dictionary, determined by `filetype` and provide
a `build` and `run` command.

```vim
let g:lterm_code_scripts = {
    \ 'cpp': {
    \     'build': printf('g++ -std=c++17 %s', expand('.')),
    \     'run':   printf('cat input | ./a.out')
    \   },
    \ }
```

Set the shell to PowerShell in windows along with some additional necessary options:

```vim
" init.vim

set shell=powershell
set shellcmdflag=-c
set shellquote=\"
set shellxquote=
```
