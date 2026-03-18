
" =========================
" BASIC SETTINGS
" =========================

set nocompatible
syntax on
filetype plugin indent on

set encoding=utf-8
set number
set relativenumber
set cursorline

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

set scrolloff=5
set hidden
set nowrap

set ignorecase
set smartcase
set incsearch
set hlsearch

set updatetime=100

" True color (IMPORTANT for kitty)
if has("termguicolors")
  set termguicolors
endif


" =========================
" LINE NUMBER COLORS
" =========================

highlight LineNr guifg=#5c6370 guibg=NONE
highlight CursorLineNr guifg=#ffcb6b guibg=NONE gui=bold
highlight CursorLine guibg=NONE


" =========================
" SEARCH using ripgrep
" =========================

set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
set grepformat=%f:%l:%c:%m

nnoremap <leader>f :grep<space>
nnoremap <leader>g :copen<CR>


" =========================
" FZF SETTINGS
" =========================

nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <leader>b :Buffers<CR>


" =========================
" PLUGIN SECTION
" =========================

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'

Plug 'joshdick/onedark.vim'

call plug#end()


" =========================
" COLORSCHEME
" =========================

colorscheme onedark


" =========================
" GO SETTINGS
" =========================

let g:go_fmt_command = "goimports"
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'


" =========================
" RUST SETTINGS
" =========================

let g:rustfmt_autosave = 1


" =========================
" FOLDING
" =========================

set foldmethod=syntax
set foldlevel=99


" =========================
" BETTER SPLITS
" =========================

set splitright
set splitbelow


" =========================
" FAST SAVE / QUIT
" =========================

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

highlight Normal guibg=NONE ctermbg=NONE
highlight NormalNC guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight CursorLineNr guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight VertSplit guibg=NONE ctermbg=NONE
highlight StatusLine guibg=NONE ctermbg=NONE
highlight StatusLineNC guibg=NONE ctermbg=NONE
highlight FoldColumn guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE

