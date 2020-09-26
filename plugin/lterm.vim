let s:lterm_window = -1
let s:lterm_buffer = -1
let s:lterm_job_id = -1

" either vertical or horizontal
let g:lterm_direction_cmd = 'vnew'

function! LtermDirection()
	if !exists(g:lterm_direction_cmd)
		return 'vnew'
	else
		return g:lterm_direction_cmd
endfunction

function! LtermOpen()

	" if not exist
	if !bufexists(s:lterm_buffer)
		" create the lterm buffer

		exec LtermDirection()

		" set the job id
		let s:lterm_job_id = termopen($SHELL)

		" change name of buffer
		silent file lterm_b

		" set window and buffer ids
		let s:lterm_window = win_getid()
		let s:lterm_buffer = bufnr('%')

		" don't show in buffer list
		set nobuflisted

	" if not currently shown
	elseif !win_gotoid(s:lterm_window)

		" open the buffer in a split window
		exec LtermDirection()
		buffer lterm_b

		" set window id
		let s:lterm_window = win_getid()
	endif
endfunction

function! LtermToggle()
	if win_gotoid(s:lterm_window)
		call LtermClose()
	else
		call LtermOpen()
	endif
endfunction

function! LtermClose()
	if win_gotoid(s:lterm_window) | hide | endif
endfunction

function! LtermExec(cmd)

	" open if needed
	if !win_gotoid(s:lterm_window)
		call LtermOpen()
	endif

	" send command
	call chansend(s:lterm_job_id, a:cmd . "\n")

	" go to bottom
	normal! G

	" go to previous window where you came from
	wincmd p
endfunction

let s:cpp_compile = 'g++ -std=c++11 -DFEAST_LOCAL ' . expand('%')

let filename = expand('%')
let filename_noext = expand('%:r')

let g:lterm_code_scripts = {
			\ 'python': { 'build': '', 'run': printf('cat input | python %s', filename) },
			\ 'cpp': { 'build': printf('g++ -std=c++11 -DFEAST_LOCAL %s', filename), 'run': printf('cat input | ./a.out') },
			\ 'java': { 'build': printf('javac %s', filename), 'run': printf('cat input | java %s', filename_noext) },
			\ }

" augroup LtermCmds
" 	autocmd!
" 	autocmd FileType python command! LtRun call LtermExec('cat input | python ' . expand('%'))
" 	autocmd Filetype java command! LtBuild call LtermExec('javac ' . expand('%'))
" 	autocmd Filetype java command! LtRun call LtermExec('cat input | java ' . expand('%:r'))
" 	autocmd FileType cpp command! LtBuild call LtermExec(s:cpp_compile)
" 	autocmd FileType cpp command! LtRun call LtermExec('cat input | ./a.out')
" augroup END

command! LtBuild call LtermExec(g:lterm_code_scripts[&filetype])
command! LtRun call LtermExec(g:lterm_code_scripts[&filetype])
