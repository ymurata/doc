if &compatible
  set nocompatible
endif

" Required:
set runtimepath+=/Users/ymurata/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  " toml ファイルを追加する
  call dein#load_toml('~/.nvim/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.nvim/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#load_toml('~/.nvim/nvim/dein_python.toml', {'lazy': 1})
  call dein#load_toml('~/.nvim/nvim/dein_go.toml', {'lazy': 1})
  call dein#load_toml('~/.nvim/nvim/dein_front.toml', {'lazy': 1})
  " call dein#load_toml('~/.nvim/nvim/dein_elixir.toml', {'lazy': 1})
  " call dein#load_toml('~/.nvim/nvim/dein_ruby.toml', {'lazy': 1})
  " call dein#load_toml('~/.nvim/nvim/dein_php.toml',     {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" nvim の基本設定
" カラースキーム
syntax on
set background=dark
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

"クリップボード共有
if has("clipboard")
  vmap ,y "+y
  nmap ,p "+gp
  " exclude:{pattern} must be last ^= prepend += append
  if has("gui_running") || has("xterm_clipboard")
    silent! set clipboard^=unnamedplus
    set clipboard^=unnamed
  endif
endif
set clipboard+=unnamed

" Swap ファイルと Backup ファイルの無効化
set nowritebackup
set nobackup
set noswapfile


" 不可視文字の可視化
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%

" 行番号の表示
set number

" 長いテキストの折り返し
set wrap

" 自動的に改行が入るのを無効化
set textwidth=0

"" 検索設定
" 検索オプション
set ignorecase " 大文字小文字を区別しない
set smartcase  " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索マッチテキストをハイライト

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"" 編集設定
" tab をスペースに変換する
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" キーバインド設定
" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
if has('nvim')
    nmap <BS> <C-W>h
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" make, grep などのコマンド後に自動的に QuickFix を開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFix および Help では q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

augroup GolangSettings
  autocmd!
  " autocmd FileType go nmap <leader>gb <Plug>(go-build)
  " autocmd FileType go nmap <leader>gt <Plug>(go-test)
  " autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
  " autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  " autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
  " autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
  " autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  autocmd FileType go :highlight goErr cterm=bold ctermfg=214
  autocmd FileType go :match goErr /\<err\>/
augroup END
