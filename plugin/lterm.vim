let s:lterm_window = -1
let s:lterm_buffer = -1
let s:lterm_job_id = -1

function! LtermDirection()
    if !exists('g:lterm_direction_cmd')
        return 'vnew'
    else
        return g:lterm_direction_cmd
    endif
endfunction

function! LtermOpen(...)

    let direction = 'new'
    if len(a:000) == 1
        let direction = a:0
    else
        let direction = LtermDirection()
    endif

    " if not exist
    if !bufexists(s:lterm_buffer)
        " create the lterm buffer

        exec direction

        " set the job id
        let s:lterm_job_id = termopen($SHELL)

        " change name of buffer
        silent file lterm_b

        " set window and buffer ids
        let s:lterm_window = win_getid()
        let s:lterm_buffer = bufnr('%')

        " don't show in buffer list
        set nobuflisted

		" don't show line numbers
		set nonumber norelativenumber

    " if not currently shown
    elseif !win_gotoid(s:lterm_window)

        " open the buffer in a split window
        exec direction
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

if !exists('g:lterm_code_scripts')
	let g:lterm_code_scripts = {
				\ 'python': { 'build': '', 'run': printf('cat input | python %s', expand('%')) },
				\ 'cpp': { 'build': printf('g++ -std=c++11 %s', expand('%')), 'run': printf('cat input | ./a.out') },
				\ 'java': { 'build': printf('javac %s', expand('%')), 'run': printf('cat input | java %s', expand('%:r')) },
				\ 'c': { 'build': printf('gcc %s', expand('%')), 'run': printf('cat input | ./a.out') },
				\ }
endif

function! LtermExecCodeScript(ft, type) abort
    if !has_key(g:lterm_code_scripts, a:ft)
        throw printf('filetype not found: %s', a:ft)
    endif

    let ft_dict = get(g:lterm_code_scripts, a:ft)

    if !has_key(ft_dict, a:type)
        throw printf('command type not found: %s', a:type)
    endif

    let cmd = get(ft_dict, a:type)

    call LtermExec(cmd)

endfunction

command! LtBuild call LtermExecCodeScript(&filetype, 'build')
command! LtRun call LtermExecCodeScript(&filetype, 'run')
