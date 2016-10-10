" call pathogen#runtime_append_all_bundles()

filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'mattn/gist-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'leafgarland/typescript-vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'lervag/vimtex'
Plugin 'mattn/webapi-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ctrlpvim/ctrlp.vim'

call vundle#end()

filetype plugin indent on
syntax enable

runtime macros/matchit.vim

let mapleader = '\'
let maplocalleader = '\'
map <Space> <localleader>

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

set showcmd
set ruler
set redraw
set showmode

" solarized colorscheme
if has('gui_running')
  let g:solarized_termcolors=256
else
  let g:solarized_termcolors=16
endif
set background=dark
" let g:solarized_visibility = 'high'
colorscheme solarized

" Ignore case while searching
se ignorecase

" Store swap files in this directory
se directory=~/.vim/tmp
se smartcase

" This is just for gvim. a autoyanks everything in the 'v' mode
set guioptions=a
set guicursor+=a:blinkon0
set title

set sh=/bin/bash
"set scrolloff=3
set hidden

set autoindent
set backspace=2
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:·\ ,trail:#

set wildmenu
set wildmode=list:longest
set history=1000

set autowriteall

se matchpairs=(:),{:},[:],<:>

" LaTeX stuff
" Set appropriate makeprg for TeX-Documents
autocmd BufRead,BufNewFile *.tex call SetTeXStuff()

function! SetTeXStuff()
	set makeprg=xelatex\ main.tex
	map j gj
	map k gk
endfunction

autocmd BufNewFile,BufRead *.cpp,*.hpp set syntax=cpp11
autocmd BufNewFile,BufRead *.hs SpacesNoTabs

" Highlight trailing whitespace and leading (non-tab) whitespace
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" autocmd BufEnter * match ExtraWhitespace /\s\+$/ | 2match ExtraWhitespace /^ \+/

" set t_Co=256
" colorscheme zenburn

" Mappings and abbreviations
" map <Leader>t <CR>
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_cmd = 'CtrlP'
map <F7> :highlight clear ExtraWhitespace<CR>
map <Up> 3<C-y>
map <Down> 3<C-e>
map <Leader>i :r! suggest_includes.sh %<CR>
" map <Leader>l :! include_lint.sh %<CR>
" map <Leader>g :0r! /home/niels/projects/sgeutils/sgebuild_gcc/bin/generate_includeguard %:p<CR>:1<CR>
map <Leader>g :YcmCompleter GoToDefinition<CR>
map <Leader>/ ma_i// <Esc>`a
map <F8> :nohlsearch<CR>

command! SpacesNoTabs call SpacesNoTabs()
function! SpacesNoTabs()
	execute 'set expandtab'
	execute 'set tabstop=2'
	execute 'set shiftwidth=2'
endfunction

" glsl stuff
command! SetGLSLFileType call SetGLSLFileType()
function! SetGLSLFileType()
	for item in getline(1,10)
		if item =~ "#version 400"
			execute ':set filetype=glsl400'
			return
		endif
		if item =~ "#version 330"
			execute ':set filetype=glsl330'
			return
		endif
	endfor

	execute ':set filetype=glsl'
endfunction

" XML prettifying
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()


" glsl syntax highlighting
autocmd BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl SetGLSLFileType
autocmd! BufRead,BufNewFile *.json se ft=json
autocmd! BufRead,BufNewFile *.doxygen se ft=doxygen
autocmd! BufRead,BufNewFile *.md se ft=markdown

let g:paths = ['/home/niels/projects/spacegameengine','/home/niels/projects/fcppt','/home/niels/projects/mizuiro','/home/niels/projects/awl','/home/niels/projects/rucksack','/home/niels/projects/sanguis']
" set path=/home/niels/projects/spacegameengine/include,/home/niels/projects/fcppt/include,/home/niels/projects/mizuiro/include,/home/niels/projects/awl/include,/home/niels/projects/sanguis/creator/include,/home/niels/projects/sanguis/creator/src/include

let g:github_user = 'nmeyering'
let g:github_token = ''

"let g:clang_use_library = 1
"let g:clang_library_path = '/usr/lib64/llvm'
autocmd vimenter * if !argc() | NERDTree | endif

highlight SpecialKey ctermfg=240 guifg=#5b605e

let g:js_context_colors = [ 252, 10, 11, 172, 1, 161, 63 ]

" 2016-03 vimtex doesn't work with 'plaintex' filetype!
let g:tex_flavor = 'tex'

let g:vimtex_latexmk_options = '-pdf -xelatex -synctex=1'
let g:vimtex_view_method = 'zathura'
