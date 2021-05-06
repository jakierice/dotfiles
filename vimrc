"""""""""""""""""""""PLUGINS""""""""""""""""""""""""""""
set noswapfile
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif

  " Run PlugInstall if there are missing plugins
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Vim tools
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jremmen/vim-ripgrep'
Plug 'leafgarland/typescript-vim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'Yggdroot/indentLine'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Themes and other styles
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'crusoexia/vim-monokai'
Plug 'ryanoasis/vim-devicons'
Plug 'aloussase/cyberpunk'

" Initialize plugin system
call plug#end()

""""""""""""""""""""KEY MAPPING"""""""""""""""""""""""""
" Leader
let mapleader = " "

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" quick `roll` ESC
imap kj <Esc>
imap jk <Esc>
vmap kj <Esc>
vmap jk <Esc>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" line number relative to current cursor position
set number
set relativenumber

" jump to beginning of line text instead of actual line begin
nmap 0 ^

" move down/up single line if line is wrapped
nmap k gk
nmap j gj

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" map Ctrl-Shift-I to Prettier like VS Code
nmap <C-i> :Prettier<CR>
nmap <C-m> :CocCommand eslint.executeAutofix<CR>

" Softtabs, 2 spaces
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  "" Use ag in fzf for listing files. Lightning fast and respects
  " .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

""""""""""""" Color Schemes  """"""""""""""""""
set termguicolors
" colorscheme onedark
" colorscheme pt_black
colorscheme monokai
" colorscheme night-owl

set encoding=UTF-8

hi CocErrorFloat ctermfg=White guifg=#ff4040

" remove theme background to use terminal theme background color
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi CursorLineNr guibg=NONE ctermbg=NONE
"
" markdown preview hotkey
let vim_markdown_preview_hotkey='<C-q>'
" default chrome for markdown preview
let vim_markdown_preview_browser='Google Chrome'
" use grip for GitHub style markdown preview
let vim_markdown_preview_github=1

" sets each level of indentation to different line type
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

"""""""" Vim lightline   """""

augroup ResizeCmdOnVimResized
  autocmd!
  autocmd VimResized * call ResizeCmdHeight()
augroup END

highlight LineNr ctermfg=grey

autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

" " COC Language Server Protocal, completion,
let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-tsserver', 'coc-eslint', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier', 'coc-pairs']

" set Pretter command for coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

set re=0

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

