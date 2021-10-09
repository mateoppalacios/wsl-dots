" Author: Mateo Palacios
"
" Depends:
" * Vim Plug
" * Vim with Python support (or Vim Huge) for clang_complete.
" * A Nerd Font.
" * A true-color terminal.
" * Zathura and Pandoc for MarkDown preview.

" ============================== Local Settings ==============================
let mapleader = " "

set background=dark
let colors = 'gruvbox-material'

" Fixes the inconsistent terminal colors for some colorschemes.
let redefine_terminal_colors = 1

" Hides the ~ characters at empty lines.
let hide_end_of_buffer = 1

" Automatic chained completion.
let automatic_ccompletion = 1

" What style to use for the AirLine separators.
" * round " "
" * arrow ""
" * slant " "
" * default (block)
let airline_sep_style_left = 'slant'
let airline_sep_style_right = 'round'

" Displays the current system time in AirLine.
let display_time = 1

" ============================ Fix (Some) Slowness ===========================
set timeoutlen=1000
set ttimeoutlen=0

" ================================= Encoding =================================
set encoding=UTF-8
set termencoding=utf-8

scriptencoding utf-8

" ============================= Moving Cursorline ============================
augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Open the files at the last cursor position.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
    \ | exe "normal! g'\"" | endif

" =============================== Command Line ===============================
set wildmenu " Command line autocompletion.
set ignorecase

" ================================== Editor ==================================
set mouse=a
set nocompatible
filetype plugin on
set splitright
set nofoldenable
set nowrap
set backspace=2
set backspace=indent,eol,start

" Copy to the system clipboard if running inside WSL.
if has("unix")
    let lines = readfile("/proc/version")
    if lines[0] =~ "Microsoft"
        autocmd TextYankPost *
            \ if v:event.operator ==# 'y'
            \ | call system('/mnt/c/Windows/System32/clip.exe', @0)
            \ | endif
    endif
endif

" ================================== Visual ==================================
set laststatus=2
set relativenumber
set number
set colorcolumn=79
set noshowmode

autocmd FileType help wincmd J

" =============================== OmniComplete ===============================
set omnifunc=syntaxcomplete#Complete

" ============================== Tabs -> Spaces ==============================
set tabstop=4
set shiftwidth=4
set expandtab

" =============================== Clean Pasting ==============================
" From: https://superuser.com/questions/437730/always-use-set-paste-is-it-a-good-idea
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ CleanPasting()

function! CleanPasting()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

" ================================= Mappings =================================
" Completion Navigation
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("k"))

" MuComplete Mappings
imap <C-l> <plug>(MucompleteFwd)
imap <C-h> <plug>(MucompleteBwd)

" Navigating Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Resize Splits
nnoremap <silent> <leader>= :winc =<CR>

" Navigating Tabs
nnoremap J gT
nnoremap K gt

" Buffer Related Mappings
nnoremap <leader><space> :wqa!<CR>
nnoremap <silent> <leader>x :bd<CR>

" Disable Arrowkeys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Quickly edit this config file from another session.
nnoremap <leader>vc :vsplit $MYVIMRC<cr>

" Source this configuration file.
nnoremap <leader>sv :source $MYVIMRC<cr>

" ============================= Plugins Mappings =============================
" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" Floating Terminal
nnoremap <leader><CR> :FloatermNew<CR>
nnoremap <silent> <leader>t :FloatermNew --wintype=split --height=0.4<CR>
tnoremap <silent> `<CR> <C-\><C-n>:FloatermKill<CR>

tnoremap <silent> `1 <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> `1 :FloatermToggle<CR>

tnoremap <silent> `k <C-\><C-n>:FloatermNext<CR>
tnoremap <silent> `j <C-\><C-n>:FloatermPrev<CR>

nnoremap <silent> `` :FloatermNew --opener=edit fzf<CR>
nnoremap <silent> `s :FloatermNew --opener=vsplit fzf<CR>

nnoremap <silent> `p :FloatermNew gotop<CR>

" ============================== MarkDown -> PDF =============================
autocmd BufNewFile,BufRead *.md
    \ :silent !pandoc -V fontsize=12pt % -o /tmp/prev.pdf &> /dev/null &
    \ zathura --fork /tmp/prev.pdf
autocmd BufWrite *.md
    \ :silent !pandoc -V fontsize=12pt % -o /tmp/prev.pdf &> /dev/null &
autocmd VimLeave *.md
    \ :silent !pandoc -V fontsize=12pt % -o %:r.pdf &> /dev/null &
    \ if pgrep zathura; then pkill zathura; fi

" ================================== Plugins =================================
call plug#begin('~/.vim/plugged')
    " Colorschemes
    Plug 'sainnhe/gruvbox-material'
    Plug 'arcticicestudio/nord-vim'
    " Syntax
    Plug 'vim-syntastic/syntastic',
    Plug 'sheerun/vim-polyglot'
    " Smooth Scrolling
    Plug 'psliwka/vim-smoothie'
    " Chained Completion
    Plug 'lifepillar/vim-mucomplete',
    " C/C++ Accurate Completion
    Plug 'xavierd/clang_complete', {'for': ['c', 'cpp']}
    " File Tree
    Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
    " Statusline
    Plug 'vim-airline/vim-airline'
    Plug 'enricobacis/vim-airline-clock',
    " Floating Terminal
    Plug 'voldikss/vim-floaterm', {'on': 'FloatermNew'}
    " Escape insert mode without lagging.
    Plug 'jdhao/better-escape.vim'
    " Git diff markers.
    Plug 'airblade/vim-gitgutter'
    " Other Utilities
    Plug 'Yggdroot/indentLine'
    Plug 'ryanoasis/vim-devicons'
    Plug 'preservim/nerdcommenter'
    Plug 'rrethy/vim-hexokinase', {'do': 'make hexokinase'}
call plug#end()

" ================================== Colors ==================================
set termguicolors

if $TERM == 'st-256color' || $TERM == 'alacritty'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" ================================ Colorscheme ===============================
let g:gruvbox_material_background = 'hard'

exec 'color ' . colors

" ============================= Hide Empty Lines =============================
if hide_end_of_buffer
    exec 'hi EndOfBuffer guifg = '
        \ . synIDattr(synIDtrans(hlID('Normal')), 'bg', 'gui')
endif

" ========================= Redefined Terminal Colors ========================
if redefine_terminal_colors
    exec "let g:terminal_ansi_colors[0] = '"
        \ . synIDattr(synIDtrans(hlID('Normal')), 'bg', 'gui') . "'"

    if g:colors_name == 'gruvbox-material'
        let g:terminal_ansi_colors[8] = '#928374'
        let g:terminal_ansi_colors[9] = '#EF938E'
        let g:terminal_ansi_colors[10] = '#BBC585'
        let g:terminal_ansi_colors[11] = '#E1BB7E'
        let g:terminal_ansi_colors[12] = '#9DC2BA'
        let g:terminal_ansi_colors[13] = '#E1ACBB'
        let g:terminal_ansi_colors[14] = '#A7C7A2'
        let g:terminal_ansi_colors[15] = '#E2D3BA'
    endif
endif

" ================================ IndentLine ================================
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_char = '│'
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" ============================= Smooth Scrolling =============================
let g:smoothie_experimental_mappings = 1

" ============================ Chained Completion ============================
let g:mucomplete#no_mappings = 1
set completeopt-=preview
set completeopt+=menuone
set shortmess+=c
set completeopt+=noinsert

" Automatic Completion
let g:clang_complete_auto = automatic_ccompletion
let g:mucomplete#enable_auto_at_startup = automatic_ccompletion

" ========================= C/C++ Accurate Completion ========================
let g:clang_library_path='/usr/lib64/libclang.so'

" ============================== Split Separator =============================
set fillchars+=vert:│
hi VertSplit ctermbg = NONE guibg = NONE

" ================================= NERDTree =================================
let g:NERDTreeMinimalUI=1
let g:NERDTreeWinSize=25

" Exit Vim if NERDTree is the last window.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
    \ && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Prevent other buffers from replacing NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+'
    \ && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" |
    \ execute 'buffer'.buf | endif

" Hide / after directories names.
augroup nerdtreehidetirslashes
    autocmd!
    autocmd FileType nerdtree syntax match
    \ NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained
augroup end

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" ============================== NERDTree Colors =============================
" Use the (hopefully) well defined terminal colors.
let blue = g:terminal_ansi_colors[4]
let green = g:terminal_ansi_colors[2]
let grey = g:terminal_ansi_colors[8]

exec 'hi! NERDTreeOpenable guifg=' . blue
exec 'hi! NERDTreeClosable guifg=' . blue

exec 'hi! NERDTreeDir guifg=' . blue
exec 'hi! NERDTreeExecFile guifg=' . green

hi link NERDTreeFlags Fg

" =============================== Status Line ================================
let g:airline_section_z = '%3p%%'

let g:airline_inactive_alt_sep = 1

" Custom Separators
let seps = {
    \ 'round': ['', '', '', ''],
    \ 'arrow': ['', '', '', ''],
    \ 'slant': [' ', ' ', '', ''],
    \ 'default': ['', '', '', '']
    \ }

let g:airline_left_sep      = seps[airline_sep_style_left][0]
let g:airline_left_alt_sep  = seps[airline_sep_style_left][2]
let g:airline_right_sep     = seps[airline_sep_style_right][1]
let g:airline_right_alt_sep = seps[airline_sep_style_left][3]

" Don't warn about C style comments.
let g:airline#extensions#whitespace#mixed_indent_algo = 1

let g:airline#extensions#clock#auto = display_time
let g:airline#extensions#clock#format = ' %I:%M %p'

" Git Hunks
let g:airline#extensions#hunks#non_zero_only = 1

let g:airline#extensions#hunks#hunk_symbols = [
    \ ' ',
    \ ' ',
    \ ' '
    \ ]

" ================================= Tab Line =================================
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" No useless information.
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#buffers_label = ''

" No tab count.
let g:airline#extensions#tabline#show_tab_count = 0

" No right tab name.
let g:airline#extensions#tabline#show_splits = 0

" Disable terminal integration as it is inconsistent with the colorschemes.
let g:airline#extensions#term#enabled = 0

let g:airline#extensions#tabline#close_symbol = ''

" ============================= Floating Terminal ============================
let g:floaterm_title = 0
let g:floaterm_autoclose = 2
let g:floaterm_borderchars = '─│─│╭╮╯╰'

hi def link FloatermBorder Fg

" ============================= Git Diff Markers =============================
let g:gitgutter_preview_win_floating = 1

let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'
let g:gitgutter_sign_removed_first_line = '┃'
let g:gitgutter_sign_removed_above_and_below = '┃'
let g:gitgutter_sign_modified_removed = '┃'

" ============================== NERD Commenter ==============================
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1

" ================================ Hexokinase ================================
let g:Hexokinase_highlighters = [ 'backgroundfull' ]
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba'
