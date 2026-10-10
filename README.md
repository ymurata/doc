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

## Claude Code / Cursor の端末全体の設定

| ファイル | 配置先 | 内容 |
| --- | --- | --- |
| agents/AGENTS.md | ~/.claude/AGENTS.md | 全プロジェクト共通の指示 (正本) |
| claude/CLAUDE.md | ~/.claude/CLAUDE.md | `@~/.claude/AGENTS.md` を import する |
| claude/settings.json | ~/.claude/settings.json | 言語、permissions、memory の設定 |
| cursor/cli-config.json | ~/.cursor/cli-config.json | Cursor CLI の permissions |

```
mkdir -p ~/.claude ~/.cursor
ln -s ~/repos/ymurata/doc/agents/AGENTS.md ~/.claude/AGENTS.md
ln -s ~/repos/ymurata/doc/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/repos/ymurata/doc/claude/settings.json ~/.claude/settings.json
ln -s ~/repos/ymurata/doc/cursor/cli-config.json ~/.cursor/cli-config.json
```

既に同名のファイルがある場合は、内容を確認してから移動する。

- Claude Code は、作業ディレクトリかその上位に CLAUDE.md が無い場合にだけ AGENTS.md を読む。ユーザースコープの AGENTS.md を読むという記載は公式に無いため、CLAUDE.md から `@` で import している (https://code.claude.com/docs/en/memory)。
- Cursor の User Rules はファイルでは管理できず、UI (Settings → Rules) で設定する。agents/AGENTS.md の内容を貼り付ける。プロジェクト側の AGENTS.md は Cursor も読む。
- Cursor で端末全体にファイルで設定できるのは `~/.cursor/mcp.json` と `~/.cursor/cli-config.json` のみ。mcp.json は使う MCP サーバーが決まってから追加する。
- permissions は deny → ask → allow の順に評価される。必要になったら allow を足す。

### memory の棚卸し

auto memory は `~/.claude/projects/<project>/memory/` に保存される。`MEMORY.md` は先頭 200 行または 25KB までしか起動時に読まれない。

- `/memory` で memory ファイルの一覧、auto memory のオン/オフ、フォルダの確認・編集ができる
- `/context` の Memory files で、起動時に読まれているファイルを確認する
- `/doctor prompt-audit` で、古い記述、存在しない参照、ファイル間の矛盾を検出する。修正は頼むまで適用されない
- 棚卸しでは、重複の統合、古い記録の削除、CLAUDE.md や AGENTS.md との矛盾の解消を行う
- CLAUDE.md は 1 ファイル 200 行未満に保つ
