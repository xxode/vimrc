set nocompatible					" be iMproved, required
set hidden							" required by CtrlSpace
cd ~								" set home as working directory

" Plugins (using vim-plug) {{{ 
call plug#begin()
Plug 'beigebrucewayne/Turtles'		" Turtles theme
Plug 'tpope/vim-fugitive'			" Git commands
Plug 'airblade/vim-gitgutter'		" Git gutter
Plug 'tpope/vim-commentary'			" commenting
Plug 'wesQ3/vim-windowswap'			" window swap
Plug 'godlygeek/tabular'			" table styling
Plug 'chrisbra/NrrwRgn'				" narrow region select
Plug 'itchyny/lightline.vim'		" statusline / tabline
Plug 'vim-ctrlspace/vim-ctrlspace'	" space manager
Plug 'ctrlpvim/ctrlp.vim'			" fuzzy finder
Plug 'scrooloose/nerdtree'			" tree explorer
Plug 'vim-scripts/YankRing.vim'		" yanks/deletes history
call plug#end()
" }}}

"" General
set number				" Show line numbers
set visualbell			" Use visual bell (no beeping)
" set cursorline			" Enable cursor line
set laststatus=2
set noshowmode			" Disable mode in statusline
set showtabline=1		" Enable tabline

set incsearch			" Enable increment search
set hlsearch			" highlight search

set tabstop=4			" Number of spaces per Tab
set shiftwidth=4		" Number of auto-indent spaces
set smartindent			" Enable smart-indent
set smarttab			" Enable smart-tabs
set autoindent			" Auto-indent new lines

set enc=utf-8
set fileencoding=utf-8

set autochdir			" Change working directory to open buffer

set gfn=Source\ Code\ Pro:h9,Bitstream\ Vera\ Sans\ Mono:h9
set guioptions=ac

colors turtles

"" Mapping
let mapleader = ","
map <leader>n :NERDTreeToggle<CR>


" CtrlSpace {{{
let g:CtrlSpaceUseUnicode = 0
let g:CtrlSpaceSymbols = {
	\ 'Tabs': '[_]',
	\ 'CTab': '[x]',
	\ 'WLoad': 'LOAD',
	\ 'WSave': 'SAVE',
	\ 'Zoom': 'ZOOM',
	\ 'SLeft': '|Search: ',
	\ 'SRight': '|',
	\ 'IA': '@'
	\ }
let g:CtrlSpaceUseTabline = 0
let g:CtrlSpaceCacheDir = expand("$HOME/vimfiles")
" }}}

" NERDTree {{{
let g:NERDTreeChDirMode=2

" close vim if only window is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" lightline {{{
let g:lightline = {
	\ 'active': {
	\	'left': [
	\		[ 'mode', 'paste', 'spell' ],
	\		[ 'gitbranch' ],
	\		[ 'filename', 'readonly' ]
	\	],
	\	'right': [
	\		[ 'wordcount', 'lineinfo' ],
	\		[ 'fileformat', 'fileencoding' ],
	\		[ 'filetype' ]
	\	]
	\ },
	\ 'inactive': {
	\	'left': [ [ 'filename' ] ],
	\	'right': [ [ 'lineinfo' ] ]
	\ },
	\ 'component': {
	\	'lineinfo': '%3p%%  %3l:%-2v'
	\ },
	\ 'component_function': {
	\	'filename': 'LightlineFilename',
	\	'gitbranch': 'LightlineFugitive',
	\	'wordcount': 'LightlineWordcount'
	\ },
\ }

function! LightlineFilename()
	let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	let modified = &modified ? ' +' : ''
	return filename . modified
endfunction

function! LightlineFugitive()
	if exists('*fugitive#head')
		let branch = fugitive#head()
		return branch !=# '' ? ' '.branch : ''
	endif
	return ''
endfunction

function! LightlineWordcount()
	if &ft =~ '\vhelp|markdown|rst|org|text|asciidoc|tex|mail|'
		let s:old_status = v:statusmsg
		let position = getpos(".")
		let l:mode = mode()
		if l:mode =~ '\vs|S'
			return ''
		endif
		exe ":silent normal g\<c-g>"
		let stat = v:statusmsg
		let s:word_count = 0
		if stat != '--No lines in buffer--'
			if l:mode =~ '\vv|V'
				let s:word_count = str2nr(split(v:statusmsg)[5])
			else
				let s:word_count = str2nr(split(v:statusmsg)[11])
			end
			let v:statusmsg = s:old_status
		end
		call setpos('.', position)
		if s:word_count >= 1000
			return substitute(string(s:word_count), '\d\@<=\(\(\d\{3\}\)\+\)$', ',&', 'g').' w'
		endif
		return s:word_count.' w'
	endif
	return ''
endfunction
" }}}












"" vim:fdm=marker
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
