" ============================================================
" 基本設定
" ============================================================
set nocompatible
set encoding=utf-8
filetype plugin indent on


" ============================================================
" プラグイン管理 (terminal のみ)
" ============================================================
if exists('g:vscode')
  " VSCode Neovim 拡張から起動した場合は何もしない
else
  let s:dein_dir      = expand('~/.cache/dein')
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  if &runtimepath !~# '/dein.vim'
    execute 'set runtimepath+=' . s:dein_repo_dir
  endif

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let s:toml_dir = expand('~/repos/doc/nvim')
    call dein#load_toml(s:toml_dir . '/dein.toml',        {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/dein_lazy.toml',   {'lazy': 1})
    call dein#load_toml(s:toml_dir . '/dein_python.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/dein_front.toml',  {'lazy': 0})

    call dein#end()
    call dein#save_state()
  endif

  " 未インストールのプラグインがあれば自動インストール
  if dein#check_install()
    call dein#install()
  endif
endif


" ============================================================
" 表示設定
" ============================================================
syntax enable
set background=dark
set number        " 行番号を表示
set wrap          " 長い行を折り返す
set list          " 不可視文字を可視化
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%

" カラースキーム (terminal のみ: プラグインが必要)
if !exists('g:vscode')
  let g:hybrid_use_iTerm_colors = 1
  colorscheme hybrid
endif


" ============================================================
" 検索設定
" ============================================================
set ignorecase   " 大文字小文字を区別しない
set smartcase    " 検索文字に大文字がある場合は区別する
set wrapscan     " 末尾まで検索したら先頭に戻る
set hlsearch     " 検索語をハイライト表示
set incsearch    " インクリメンタルサーチ
set inccommand=split  " 置換をインタラクティブにプレビュー


" ============================================================
" 編集・インデント設定
" ============================================================
set expandtab     " タブをスペースに変換
set tabstop=4     " タブ幅
set softtabstop=4 " 入力時のタブ幅
set shiftwidth=4  " 自動インデント幅
set autoindent    " 自動インデント
set textwidth=0   " 自動改行を無効化
set backspace=indent,eol,start  " バックスペースで何でも消せるようにする
set hidden        " 未保存バッファがあっても別バッファに切り替え可能
set clipboard+=unnamedplus      " クリップボード連携


" ============================================================
" ファイル・履歴設定
" ============================================================
set history=1000   " コマンド履歴の保持数
set noswapfile     " swap ファイルを作成しない
set noundofile     " undo ファイルを作成しない
set nobackup       " backup ファイルを作成しない
set nowritebackup  " writebackup ファイルを作成しない
set viminfo=       " viminfo ファイルに保存しない


" ============================================================
" キーマップ
" ============================================================
" ESC を2回押してハイライトを消去
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" jj で Insert モードを抜ける
inoremap jj <Esc>

" j / k を折り返し行でも自然に動作させる
nnoremap j gj
nnoremap k gk

" 検索ジャンプ後に画面中央に移動
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" v を2回押して行末まで選択
vnoremap v $h

" Tab で対応するペアにジャンプ
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

" / ? をコマンドラインで自動エスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" w!! でスーパーユーザーとして保存
cmap w!! w !sudo tee > /dev/null %


" ============================================================
" 自動コマンド
" ============================================================
" ============================================================
" LSP / 補完 / フォーマット / treesitter
" ============================================================
lua << EOF
-- LSP (pyright)
vim.lsp.config('pyright', {
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { 'pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' })
    cb(root or vim.fn.expand('%:p:h'))
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoImportCompletions = true,
      }
    }
  }
})
vim.lsp.enable('pyright')

-- LSP (typescript)
vim.lsp.config('ts_ls', {})
vim.lsp.enable('ts_ls')

-- 補完 (nvim-cmp)
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<Tab>']     = cmp.mapping.select_next_item(),
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- フォーマット (conform)
require('conform').setup({
  formatters_by_ft = {
    python          = { 'isort', 'autopep8' },
    typescript      = { 'prettier' },
    typescriptreact = { 'prettier' },
    javascript      = { 'prettier' },
    javascriptreact = { 'prettier' },
    css             = { 'prettier' },
    json            = { 'prettier' },
  },
  format_on_save = {
    timeout_ms   = 3000,
    lsp_fallback = true,
  },
})

EOF

" treesitter は VimEnter 後に設定
autocmd VimEnter * lua require('nvim-treesitter.config').setup({ ensure_installed = { 'python', 'typescript', 'tsx', 'javascript' }, highlight = { enable = true }, indent = { enable = true } })

augroup MyAutoCmd
  autocmd!
  " make / grep 後に自動的に QuickFix を開く
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
  " QuickFix / Help では q でバッファを閉じる
  autocmd FileType help,qf nnoremap <buffer> q <C-w>c
augroup END

augroup GolangSettings
  autocmd!
  autocmd FileType go highlight goErr cterm=bold ctermfg=214
  autocmd FileType go match goErr /\<err\>/
augroup END
