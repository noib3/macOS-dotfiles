" TODO
" NEOVIM
" 1. vim look into autogroups and ftplugin files
" 2. silence compile command for latex and content
" 3. tex file closes other pdfs not only his own fix that
" 4. vim handle copying and pasting of unicode chars like lambda or plus/minus symbols

" LF
" 1. lf move around with cmd-d and edit file with cmd-e
" 2. lf set natural ordering like ls -l
" 3. lf report issue with updating files on external volumes
" 4. lf report issue with status bar being empty on startup

" FIREFOX
" 1. firefox hide tab bar if single tab open, show on hover
" 2. firefox make .app to open torrents
" 3. firefox make bookmarks setup
" 4. firefox make bitwarden setup
" 5. firefox make downloads setup

" OTHER
" 1. cmd-e and cmd-d fix colors
" 2. understand why sometimes when it's launched with fzf_opener it looks fucked up
" 3. fzf launcher support for multiple files
" 4. fzf launcher sometimes it doesn't launch
" 5. fix all skhd yabai bindings, for ex alt+w with a program on space 3 but spawned from space 2 puts it on space 1
" 6. refactor skhd and yabai configs

" TO CREATE
" 1. refactor committed script, calcurse.pid doesn't get pushed, I only try to commit if there is something to commit, option to clear the screen for every git folder
" 2. refactor peek script, see why it throws an error, remove creation of tmp file, program gets pulled from keep once the workout is over
" 3. setup bar with uebersicht
" 4. refactor 2d2small and journal classes
" 5. make program to track time, a binding brings up a menu with the current tasks open, if you click on one it continues that task and tracks the time, binding to stop the task, data saved in json/yaml file, web frontend
" 6. finances web frontend
" 7. remake ndiet

" Plugs
call plug#begin('~/.config/nvim/plugged')
  " syntax
  Plug 'tridactyl/vim-tridactyl'
  " functionality
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'farmergreg/vim-lastplace'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Yggdroot/indentLine'
  Plug 'junegunn/goyo.vim'
  Plug 'lervag/vimtex'
  " colorschemes
  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
call plug#end()

" Sets
set splitright splitbelow
set number relativenumber
set shiftwidth=4
set tabstop=4
set expandtab
set clipboard+=unnamedplus
set termguicolors
set noshowmode
set undofile
set laststatus=0

" Lets
let mapleader=","
let maplocalleader=","
let g:netrw_home=$HOME.'/.cache/nvim'
let g:tex_conceal=''
let g:is_posix=1

" vimtex
" let g:vimtex_mappings_enabled=0

" indentLine
let g:indentLine_char='│'
let g:indentLine_first_char='│'
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_fileTypeExclude=['text']
let g:indentLine_defaultGroup='Comment'

" Maps
map  <C-a> ^
imap <C-a> <esc>^i
map  <C-e> $
imap <C-e> <esc>$a

map  <silent> <C-s> :w<cr>
imap <silent> <C-s> <esc>:w<cr>a
map  <silent> <C-w> :q<cr>
imap <silent> <C-w> <esc>:q<cr>

noremap <leader>w <C-w><C-k>
noremap <leader>a <C-w><C-h>
noremap <leader>s <C-w><C-j>
noremap <leader>d <C-w><C-l>

nmap ss :%s//g<left><left>
nmap <silent> <leader>c :execute "set cc=" . (&cc == "" ? "80,100" : "")<cr>

" Fix for https://github.com/neovim/neovim/issues/11393
cnoremap 3636 <c-u>undo<CR>

" Colorscheme
colorscheme onedark

" Highlights
highlight Normal guibg=NONE ctermbg=NONE
highlight Visual guibg=#7aa6da guifg=#ffffff ctermbg=blue ctermfg=white
highlight Comment gui=italic cterm=italic

highlight TabLineSel guibg=#626262 guifg=#ebebeb
highlight TabLine guibg=#393939 guifg=#b6b6b6
highlight TabLineFill guibg=NONE guifg=NONE

highlight VertSplit guibg=#5C6370 guifg=NONE
highlight StatusLine guibg=#5C6370 guifg=NONE
highlight StatusLineNC guibg=#5C6370 guifg=NONE

" Change vertical split character to a space
set fillchars=vert:\  "

" Autocmds
autocmd FileType    * setlocal formatoptions-=cro
autocmd BufWritePre * call StripTrailingWhitespaces()
autocmd InsertEnter * norm zz

autocmd FileType vim,sh,zsh,python,conf execute "set cc=" . (&cc == "" ? "80,100" : "")
autocmd FileType tex,context,vim,css,yaml setlocal shiftwidth=2 tabstop=2

autocmd BufReadPost *.tex call PdfOpen()
autocmd BufUnload   *.tex call PdfClose()
autocmd FileType tex,context let g:AutoPairs['$']='$'
autocmd FileType tex,context nnoremap <buffer> <silent> <C-t> :call TeXCompile()<cr>
autocmd FileType tex,context inoremap <buffer> <silent> <C-t> <esc>:call TeXCompile()<cr>a
autocmd FileType tex,context nnoremap <buffer> <silent> <localleader>p :call PdfOpen()<cr>
autocmd FileType tex,context nnoremap <buffer> <silent> <localleader>f :call SyncTeXForwardSearch()<cr>

" Remove trailing whitespace without changing cursor position
function! StripTrailingWhitespaces()
  let [_, line, col, _, _] = getcurpos()
  execute printf('%d substitute/\%%%dc\s\+$//e', line, col+1)
  execute printf('vglobal/\%%%dl/substitute/\s\+$//e', line)
  call cursor(line, col)
endfunction

" Compile a LaTeX/ConTeXt document
function! TeXCompile()
  let filepath = expand('%:p')
  execute "!cd $(dirname ".shellescape(filepath,1).") && pdflatex -synctex=1 ".shellescape(filepath,1)
endfunction

" Open the PDF file created by a TeX document
function! PdfOpen()
  let filepath = expand('%:p:r').'.pdf'
  if filereadable(filepath)
    execute 'silent !open '.shellescape(filepath,1)
  else
    echohl ErrorMsg
    echomsg 'No pdf file "'.filepath.'"'
    echohl None
  endif
endfunction

" Close the PDF file created by a TeX document
function! PdfClose()
  let filepath = expand('%:p:r').'.pdf'
  if filereadable(filepath)
    let yabai_windows = json_decode(join(systemlist('yabai -m query --windows')))
    let skim_windows = filter(yabai_windows, 'v:val.app=="Skim"')
    " if there is just one Skim window and its title matches the filename of
    " the file in the buffer, quit Skim
    if len(skim_windows) == 1
      execute "silent !osascript -e \'quit app \"Skim\"\'"
    " if there are more Skim windows look for the one whose title matches the
    " filename of the file in the buffer and close it
    elseif len(skim_windows) > 1
      let filename = system("basename ".shellescape(filepath,1))
      for window in skim_windows
        if system("sed 's/\.pdf.*/.pdf/'", window.title) == filename
          execute "silent !yabai -m window --focus ".shellescape(window.id,1)." && yabai -m window --close && yabai -m window --focus recent"
        endif
      endfor
    endif
  endif
endfunction

" Use SyncTex to jump from a line in a TeX document to its PDF output in Skim
function! SyncTeXForwardSearch()
  let filepath = expand('%:p:r').'.pdf'
  if filereadable(filepath)
    execute "silent !/Applications/Skim.app/Contents/SharedSupport/displayline ".line(".")." ".shellescape(filepath,1)
  else
    echohl ErrorMsg
    echomsg 'No pdf file "'.filepath.'"'
    echohl None
  endif
endfunction
