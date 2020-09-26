if exists("g:lterm_autoloaded") | finish | endif
let g:lterm_autoloaded=1

function! lterm#load_terminal_keymaps()
	tnoremap <Esc> <C-\><C-n>
endfunction

function! lterm#load_keymaps()
	" load example keymaps
	nnoremap <silent> <leader>lb :LtBuild<CR>
	nnoremap <silent> <leader>lr :LtRun<CR>
	nnoremap <silent> <leader>lt :call LtermToggle()<CR>
	nnoremap <silent> <leader>lw :sb lterm_b<CR>i<Up><CR><C-\><C-n><C-w><C-p>
endfunction
