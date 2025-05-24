if exists('g:vscode')
    " vscode の場合
    echom "Neovim is working in VSCode"
endif

" 共通設定

" ESCを2回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" ######################## 検索・置換 ########################
set ignorecase " 大文字小文字の区別なく検索する
set smartcase " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan " 検索時に最後まで行ったら最初に戻る
set hlsearch " 検索語をハイライト表示
set incsearch " 検索文字列入力時に順次対象文字列にヒットさせる
set inccommand=split " インタラクティブに変更

" ######################## インデント ########################
set expandtab " softtabstop や shiftwidth で設定されている値分のスペースが挿入されたときに、挿入されたスペース数が tabstop に達してもタブに変換されない
set tabstop=4 " スペースn個分で1つのタブとしてカウントするか
set softtabstop=4 " <tab>を押したとき、n個のスペースを挿入
set shiftwidth=4 " <Enter>や<<, >>などを押したとき、n個のスペースを挿入

" ######################## 操作 ########################
set clipboard+=unnamedplus " クリップボードにコピーできるようにする
set backspace=indent,eol,start " backspaceで様々な文字を消せるようにする(デフォルトだと改行文字などはbackspaceで削除できない)
set hidden " タブを切り替えるときに保存していなくてもOKにする
set textwidth=0 "自動改行する文字数

" ######################## ログ ########################
set history=1000 "保持するコマンド履歴の数
set noswapfile " swapファイルを保存しない
set noundofile " undoファイルを保存しない
set nobackup " backupを保存しない
set nowritebackup "writebackupを保存しない
set viminfo= " viminfoファイルに保存しない

" ######################## その他 ########################
filetype plugin indent on " ファイルタイプの検索とプラグインをONにする
set encoding=utf-8 " 文字コードをutf-8にする