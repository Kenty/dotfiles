" Use the Solarized Dark theme
set background=dark
colorscheme solarized
" colorscheme molokai

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif

" -------------------
" Setting NeoBundle
" -------------------
if !1 | finish | endif

if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  set runtimepath+=~/dotfiles/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/dotfiles/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
" unite.vim {{{
let g:unite_enable_start_insert=1
nmap <silent> <C-u><C-b> :<C-u>Unite buffer<CR>
nmap <silent> <C-u><C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nmap <silent> <C-u><C-r> :<C-u>Unite -buffer-name=register register<CR>
nmap <silent> <C-u><C-m> :<C-u>Unite file_mru<CR>
nmap <silent> <C-u><C-u> :<C-u>Unite buffer file_mru<CR>
nmap <silent> <C-u><C-a> :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
au FileType unite nmap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite imap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite nmap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite imap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite nmap <silent> <buffer> <ESC><ESC> q
au FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q
" }}}
" neomru.vimproc {{{
NeoBundle 'Shougo/neomru.vim', {
  \ 'depends' : 'Shougo/unite.vim'
  \ }
" }}}
" vimproc //syntaxチェック {{{
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \   'mac': 'make -f make_mac.mak',
  \   'unix': 'make -f make_unix.mak',
  \ }}
" }}}
if has('lua')
  NeoBundleLazy 'Shougo/neocomplete.vim', {
    \ 'depends' : 'Shougo/vimproc',
    \ 'autoload' : { 'insert' : 1,}
    \ }
endif
" neocomplete {{{
let g:neocomplete#enable_at_startup               = 1
let g:neocomplete#auto_completion_start_length    = 3
let g:neocomplete#enable_ignore_case              = 1
let g:neocomplete#enable_smart_case               = 1
let g:neocomplete#enable_camel_case               = 1
let g:neocomplete#use_vimproc                     = 1
let g:neocomplete#sources#buffer#cache_limit_size = 1000000
let g:neocomplete#sources#tags#cache_limit_size   = 30000000
let g:neocomplete#enable_fuzzy_completion         = 1
let g:neocomplete#lock_buffer_name_pattern        = '\*ku\*'
" }}}
NeoBundleLazy 'Shougo/vimshell', {
  \ 'depends' : 'Shougo/vimproc',
  \ 'autoload' : {
  \ 'commands' : [{ 'name' : 'VimShell', 'complete' : 'customlist,vimshell#complete'},
  \               'VimShellExecute', 'VimShellInteractive',
  \               'VimShellTerminal', 'VimShellPop'],
  \ 'mappings' : ['<Plug>(vimshell_switch)']
  \ }}
" vimshell {{{
nmap <silent> vs :<C-u>VimShell<CR>
nmap <silent> vp :<C-u>VimShellPop<CR>
" }}}
" NERDTree {{{
NeoBundle 'scrooloose/nerdtree'
" }}}
NeoBundleLazy 'Shougo/vimfiler', {
  \ 'depends' : ['Shougo/unite.vim'],
  \ 'autoload' : {
  \   'commands' : [ 'VimFilerTab', 'VimFiler', 'VimFilerExplorer', 'VimFilerBufferDir' ],
  \   'mappings' : ['<Plug>(vimfiler_switch)'],
  \   'explorer' : 1,
  \ }}
" vimfiler {{{
let g:vimfiler_as_default_explorer  = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_data_directory       = expand('~/.vim/etc/vimfiler')
nnoremap <silent><C-u><C-j> :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit -toggle<CR>
" }}}
" vim-autoclose {{{
NeoBundle 'Townk/vim-autoclose'
" }}}
" vim-endwise:.vimrc {{{
NeoBundleLazy 'tpope/vim-endwise', {
  \ 'autoload' : { 'insert' : 1,}}
" }}}
NeoBundle 'glidenote/memolist.vim'
" memolist {{{
let g:memolist_path         = expand('~/GoogleDrive/memolist')
let g:memolist_gfixgrep     = 1
let g:memolist_unite        = 1
let g:memolist_unite_option = "-vertical -start-insert"
nnoremap mn :MemoNew<CR>
nnoremap ml :MemoList<CR>
nnoremap mg :MemoGrep<CR>
" }}}
NeoBundle 'Lokaltog/vim-easymotion'
" vim-easymotion {{{
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-s2)
xmap s <Plug>(easymotion-s2)
omap z <Plug>(easymotion-s2)
nmap g/ <Plug>(easymotion-sn)
xmap g/ <Plug>(easymotion-sn)
omap g/ <Plug>(easymotion-tn)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
let g:EasyMotion_startofline      = 0
let g:EasyMotion_keys             = 'QZASDFGHJKL;'
let g:EasyMotion_use_upper        = 1
let g:EasyMotion_enter_jump_first = 1
" }}}
NeoBundleLazy 'Shougo/neosnippet.vim', {
  \ 'depends' : 'Shougo/neosnippet-snippets',
  \ 'autoload' : {
  \   'insert' : 1,
  \   'filetypes' : 'snippet',
  \ }}
NeoBundle 'Shougo/neosnippet-snippets'
let g:neosnippet#date_directory = expand('~/.vim/etc/.cache/neosnippet')
let g:neosnippet#snippets_directory = [expand('~/.vim/.bundle/neosnippet-snippets/neosnippets'),expand('~dotfiles/snippets')]
" neosnippet {{{
imap <C-k> <plug>(neosnippet_expand_or_jump)
smap <C-k> <plug>(neosnippet_expand_or_jump)
" }}}
NeoBundleLazy 'mattn/emmet-vim', {
  \ 'autoload' : {
  \   'filetypes' : ['html', 'html5', 'eruby', 'php', 'jsp', 'xml', 'css', 'scss', 'sass', 'less', 'styl', 'coffee'],
  \   'commands' : ['<Plug>ZenCodingExpandNormal']
  \ }}
" emmet {{{
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
  \ 'lang' : 'ja',
  \ 'indentation' : '    ',
  \ 'html' : {
  \   'filters' : 'html',
  \   'indentation' : '  '},
  \ 'css' : {'filters' : 'css'},
  \ 'php' : {
  \   'filters' : 'html',
  \   'extends' : 'html',
  \   'indentation' : '  ',}}
let g:user_emmet_mode = 'a'
let g:user_emmet_complete_tag = 1
" }}}
" html5.vim {{{
NeoBundle 'othree/html5.vim'
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1
" }}}
" vim-css3-syntax {{{
NeoBundleLazy 'hail2u/vim-css3-syntax', {
  \ 'filetypes' : [
  \   'html', 'php', 'css', 'sass', 'scss', 'less']}
" }}}
" neocomplete-php {{{
NeoBundle 'violetyk/neocomplete-php.vim'
let g:neocomplete_php_locale = 'ja'
" }}}
" context_filetype.vim {{{
NeoBundle 'Shougo/context_filetype.vim'
let g:context_filetype#filetypes = {
  \ 'html' : [
  \   {
  \     'start' : '<script>',
  \     'end' : '</script>', 'filetype' : 'javascript'},
  \   {
  \     'start' : '<script\%( [^>]*\)charset="[^\"]*"\%( [^>]*\)\?>',
  \     'end' : '</script>', 'filetype' : 'javascript'},
  \   {
  \     'start' : '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
  \     'end' : '</script>', 'filetype' : 'javascript'},
  \   {
  \     'start' : '<script\%( [^>]*\)\? type="text/coffeescript"\%( [^>]*\)\?>',
  \     'end' : '</script', 'filetype' : 'coffee'},
  \   {
  \     'start' : '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
  \     'end' : '</style>', 'filetype' : 'css'},
  \   {
  \     'start' : '<?',
  \     'end': '?>', 'filetype' : 'php'}]}
let g:context_filetype#search_offset = 100
" }}}
call neobundle#end()

filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" 参考: http://qiita.com/himinato/items/caf5a0b19ce893a75363
"       http://catcher-in-the-tech.net/1063/
