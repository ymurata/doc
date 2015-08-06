" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

set nocompatible               " be iMproved

filetype off


if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'
    call neobundle#end()
    endif
    call neobundle#begin(expand('~/.vim/bundle/'))
    " originalrepos on github
    NeoBundle 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc'
    NeoBundle 'VimClojure'
    NeoBundle 'Shougo/vimshell'
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/neocomplcache'
    NeoBundle 'Shougo/neosnippet' 
    NeoBundle 'jpalardy/vim-slime'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'Shougo/neosnippet-snippets'
    NeoBundle 'scrooloose/nerdtree'
    ""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

    "" for golona
    NeoBundle 'vim-jp/vim-go-extra'
    
    " 構文チェック
    NeoBundle 'scrooloose/syntastic'
    let g:syntastic_mode_map = { 'mode': 'passive',
        \ 'active_filetypes': ['go'] }
    let g:syntastic_go_checkers = ['go', 'golint']

    NeoBundle "tyru/caw.vim.git"
    nmap <C-K> <Plug>(caw:i:toggle)
    vmap <C-K> <Plug>(caw:i:toggle)

    call neobundle#end()

    filetype plugin indent on     " required!
    filetype indent on
    syntax on

" for serach option
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト (2013-07-03 14:30 修正）

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" for edit option
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
"set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

set backspace=indent,eol,start

" SwapファイルとBackupファイルの無効化
set nowritebackup
set nobackup
set noswapfile

" for display option
set list                " 不可視文字の可視化
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
set number              " 行番号の表示
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
"set colorcolumn=80      " その代わり80文字目にラインを入れる

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

" 構文毎に文字色を変化させる
syntax on
 
" for macro option

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

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

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" for golang

" golint のプラグイン
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
filetype plugin on
" gocode を実行する
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
" golang の補完内容の詳細表示
set completeopt=menu,preview
" golang のファイル保存時に Linter を実行
autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow 
" go format
autocmd BufWritePre *.go Fmt
