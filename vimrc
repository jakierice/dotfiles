"""""""""""""""""""""PLUGINS""""""""""""""""""""""""""""
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Vim tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

" LSP config support (needed for Neovim 0.5.0 goodness)
Plug 'neovim/nvim-lspconfig'
" LSP UI supprt (hover windows and such)
Plug 'glepnir/lspsaga.nvim'
" Treesitter for tree based syntax parsing (better than regex)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Initialize plugin system
call plug#end()

""""""""""""""""""""KEY MAPPING"""""""""""""""""""""""""
" quick `roll` ESC
inoremap jk <Esc>
inoremap jj <Esc>
inoremap kj <Esc>
inoremap kk <Esc>
vmap kj <Esc>
vmap jk <Esc>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" line number relative to current cursor position
set number
set relativenumber

set noswapfile

" jump to beginning of line text instead of actual line begin
nmap 0 ^

" move down/up single line if line is wrapped
nmap k gk
nmap j gj

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" map Ctrl-Shift-I to Prettier like VS Code
nmap <C-i> :Prettier<CR>
nmap <C-m> :CocCommand eslint.executeAutofix<CR>

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

nnoremap <SPACE> <Nop>
let mapleader=" "
" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

set encoding=UTF-8

hi CocErrorFloat ctermfg=White guifg=#ff4040

" remove theme background to use terminal theme background color
hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi CursorLineNr guibg=NONE ctermbg=NONE

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden --ignore .git  -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

augroup ResizeCmdOnVimResized
  autocmd!
  autocmd VimResized * call ResizeCmdHeight()
augroup END

highlight LineNr ctermfg=grey

autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

" show hover doc
nnoremap <silent>K :Lspsaga hover_doc<CR>
" show TS signature
inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
" find the cursor word definition and reference
nnoremap <silent> gh <Cmd>Lspsaga lsp_finder<CR>
" go to next diagnostic found
nnoremap <silent> [g :Lspsaga diagnostic_jump_previous<CR>
nnoremap <silent> ]g :Lspsaga diagnostic_jump_next<CR>

set re=0
