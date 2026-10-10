# doc

.bash_profile の読み込み
https://superuser.com/questions/320065/bashrc-not-sourced-in-iterm-mac-os-x

vim のインストール手順
http://qiita.com/puriketu99/items/1c32d3f24cc2919203eb

## セットアップ

```
brew install mise neovim tree-sitter
ln -s ~/repos/ymurata/doc/bash/bash_profile ~/.bash_profile
ln -s ~/repos/ymurata/doc/nvim ~/.config/nvim
ln -s ~/repos/ymurata/doc/vim/vimrc.minimal ~/.vimrc
git clone https://github.com/Shougo/dein.vim ~/.cache/dein/repos/github.com/Shougo/dein.vim
```

言語ランタイムと nvim が必要とする外部ツールは mise でインストール

```
mise use -g python@3.12.13 node@24.13.1 go@1.25.5 uv@0.12.0
mise use -g npm:pyright npm:typescript@7 npm:prettier pipx:isort pipx:autopep8
```

uv は mise が pipx: のツールをインストールするのに使う。2 行目は nvim の LSP (pyright, TypeScript 7 の tsc --lsp) と conform のフォーマッタ

nvim の初回起動時に dein がプラグインをインストールする。インストール前に設定が読み込まれてエラーが出るため、初回は nvim を起動し直す。treesitter のパーサのビルドには C コンパイラ (Xcode Command Line Tools) が必要。

nvim/dein_go.toml, dein_ruby.toml, dein_elixir.toml, dein_flutter.toml は init.vim から読み込んでいない。使うときは init.vim に dein#load_toml を追加する。

~/.vimrc は macOS 標準の vim 用の最小設定 (swap などのファイルを作らない)。vim/vimrc は NeoBundle 用の古い設定で使っていない。
