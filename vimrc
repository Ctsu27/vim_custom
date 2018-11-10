"Activate indentation
filetype off
filetype plugin indent on
set smartindent

"Non-expanded, 4-wide tabulations
set tabstop=4
set shiftwidth=4
set noexpandtab

"Disable vi-compatibility
set nocompatible

"Real-world encoding
set encoding=utf-8

"Interpret modelines in files
set modelines=1

"Do not abandon buffers
set hidden

"Don't bother throttling tty
set ttyfast

"More useful backspace behavior
set backspace=indent,eol,start

"Use statusbar on all windows
set laststatus=2

"Better search
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

"Prevent backups when editing system files
au BufWrite /private/tmp/crontab.* set nowritebackup
au BufWrite /private/etc/pw.* set nowritebackup

"____________________Style____________________"
set nolist
set listchars=tab:→\ ,trail:·,eol:¬,extends:…,precedes:…
syntax on
colorscheme monokai
if !exists("g:colors_name")
	highlight ColorColumn	ctermbg=235
	highlight Normal		ctermbg=234
	highlight Search		ctermbg=8
	set background=dark
endif
set number
set relativenumber
set ruler
set colorcolumn=81
set foldmethod=marker
"____________________Tabs_____________________"
set tabpagemax=100
:nnoremap <silent> > :tabp<CR>
:nnoremap <silent> . :tabn<CR>
:nnoremap <silent> ++ :Texplore<CR>
:nnoremap <silent> += :tabclose<CR>
"___________________Scripts___________________"
:if (&ft=='python')
:ts=4
:syn match pythonBoolean "\(\W\|^\)\@<=self\(\.\)\@="
:let python_highlight_all = 1
:endif

autocmd Filetype html setlocal ts=2 sw=2 noexpandtab list
autocmd Filetype php setlocal ts=2 sw=2 noexpandtab list
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 noexpandtab list

autocmd FileType c setlocal comments=sr:/*,mb:**,ex:*/
autocmd FileType css setlocal comments=sr:/*,mb:**,ex:*/
autocmd FileType javascript setlocal comments=sr:/*,mb:**,ex:*/
"____________________Fcts_____________________"

"TOGGLE COMMENT____________________________ {{{

:function ToggleComment()
let l:com_s = "#"
if (&ft=='c' || &ft=='cpp')
	let l:com_s = "\/\/"
elseif (&ft=='vim')
	let l:com_s = "\""
endif

let l:line_com = getline('.')
if (match(l:line_com, l:com_s) == 0)
	if (&ft=='c' || &ft=='cpp')
		let l:com_s = "\\/\\/"
	endif
	execute 's'.'/'.l:com_s.'/'.'/'
else
	:s/^/\=l:com_s/
endif
endfunction

"TOGGLE COMMENT____________________________ }}}

"STDHEADER_________________________________ {{{

let s:asciiart = [
			\"        :::      ::::::::",
			\"      :+:      :+:    :+:",
			\"    +:+ +:+         +:+  ",
			\"  +#+  +:+       +#+     ",
			\"+#+#+#+#+#+   +#+        ",
			\"     #+#    #+#          ",
			\"    ###   ########.fr    "
			\]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php':
			\['/*', '*/', '*'],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->', '*'],
			\'\.js$':
			\['//', '//', '*'],
			\'\.tex$':
			\['%', '%', '*'],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)', '*'],
			\'\.vim$\|\vimrc$':
			\['"', '"', '*'],
			\'\.el$\|\emacs$':
			\[';', ';', '*'],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '!', '/']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= '#'
	let s:fill	= '*'

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
			let s:fill	= s:types[type][2]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
	let l:left = strpart(a:left, 0, s:length - s:margin * 3 - strlen(a:right) + 1)

	return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 11 " top and bottom line
		return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
	elseif a:n == 2 || a:n == 10 " blank line
		return s:textline('', '')
	elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
		return s:textline('', s:ascii(a:n))
	elseif a:n == 4 " filename
		return s:textline(s:filename(), s:ascii(a:n))
	elseif a:n == 6 " author
		return s:textline("By: " . s:user() . " <" . s:mail() . ">", s:ascii(a:n))
	elseif a:n == 8 " created
		return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
	elseif a:n == 9 " updated
		return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
	endif
endfunction

function! s:user()
	let l:user = $USER42
	if strlen(l:user) == 0
		let l:user = "kehuang"
	endif
	return l:user
endfunction

function! s:mail()
	let l:mail = "kehuang@student.42.fr"
	if strlen(l:mail) == 0
		let l:mail = "kehuang@student.42.fr"
	endif
	return l:mail
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
	let l:line = 11

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	call s:filetype()
	if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
		if &mod
			call setline(9, s:line(9))
		endif
		call setline(4, s:line(4))
		return 0
	endif
	return 1
endfunction

function! s:ftheader()
	if s:update()
		call s:insert()
	endif
endfunction

" Bind command and shortcut
command! Ftheader call s:ftheader ()
autocmd BufWritePre * call s:update ()

"_________________________________STDHEADER }}}

"BALISE XML________________________________ {{{
:function Ret(str)
return a:str
endfunction

:function Bl(str)
let l:appd="<". a:str . ">	</" . a:str . ">"
execute setline(line('.'), getline(line('.')) . l:appd)
execute '%s//'.''.'/g'
execute 'normal kl'
endfunction
"BALISE XML________________________________ }}}

"_____________UTILS
set mouse=a
set ignorecase
set noerrorbells
set novisualbell

"_____________MAPPING
:nnoremap q <Nop>
:nnoremap <c-p> <Nop>

let mapleader=""

:nnoremap <silent> <SPACE> :noh<CR>

":nnoremap <leader><c-w> :w<CR>
":nnoremap <leader><c-x> :q<CR>

:nnoremap <silent> <leader><c-p> :set list!<CR>

:vnoremap <silent> <SPACE> :call ToggleComment()<CR>

"_____________PLUG
execute pathogen#infect()
"let g:syntastic_c_compiler_options = '-Wall -Wextra -Wfloat-equal -Wshadow -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wwrite-strings -Waggregate-return -Wconversion -Wunreachable-code -Winit-self'
"let g:syntastic_c_compiler_options = '-Weverything'
let g:syntastic_c_compiler_options = '-Wall -Wextra -Werror -Wunreachable-code'
let g:syntastic_c_include_dirs = [ '../include', 'include', '../../includes', '../includes', 'includes', 'libft/includes/', '../libft/includes/', '../lib/include', 'lib/include']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_error_symbol = '⌘'
let g:syntastic_warning_symbol = '⦿'
