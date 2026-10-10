---
name: cursor-agent-cli
description: Cursor CLI（`agent` コマンド）を非対話（print モード）で実行し、出力形式（text / json / stream-json）、モデル指定、セッション再開、権限モードを使い分ける手順。「cursor agent で実行」「agent -p」「cursor cli でコードを変更」「cursor のモデルで質問」「前の cursor セッションを再開」「stream-json を解析」「cursor をスクリプトから呼ぶ」など、Cursor の agent CLI を別プロセスから呼び出す場面では必ずこの skill を使う。Cursor エディタ本体の操作や Cursor のルール設定だけの話では使わない。
---

# Cursor CLI (`agent`)

Cursor の CLI は `agent` コマンドとして提供される。スクリプトや別の AI エージェントから呼ぶときは、必ず `-p` (`--print`) を付けて非対話で実行する。付けないと TUI が起動し、サブシェルではハングする。

## 前提

- `agent --version` で導入を確認する。未導入なら Cursor の案内に従ってインストールする。
- 認証は `agent status` で確認する。未ログインなら `agent login` をユーザーに案内する（ブラウザ認証のため、対話が必要）。CI など対話できない環境では `CURSOR_API_KEY` 環境変数か `--api-key` を使う。
- API キーを含むファイル（`.env` など）は読まない。キーの値をログや出力に出さない。

## 基本の実行

```bash
agent -p --output-format json --trust --workspace "$PWD" --model auto "<プロンプト>"
```

- `--trust`: ワークスペースを信頼するプロンプトを省く。非対話で止まらないために付ける。
- `--workspace <path>`: 作業ディレクトリを明示する。省略時はカレントディレクトリ。
- `--add-dir <path>`: 追加の作業ルートを渡す（複数指定可）。

## 出力形式 (`--output-format`)

`--output-format` は `-p` と組み合わせたときだけ有効。既定値は `text`（`agent --help` の記載）。プログラムから読むなら明示的に指定する。

| 形式 | 用途 | 中身 |
|---|---|---|
| `text` | 人が読む | 最終回答のテキストだけ |
| `json` | 結果だけ機械的に取る | 1 つの JSON オブジェクト（下記） |
| `stream-json` | 途中経過も追う | 改行区切りの JSON イベント列 |

### json の結果オブジェクト

```json
{"type":"result","subtype":"success","is_error":false,"duration_ms":8763,"result":"OK","session_id":"b5902d0a-...","request_id":"...","usage":{"inputTokens":8616,"outputTokens":31,"cacheReadTokens":3840,"cacheWriteTokens":0}}
```

- 回答本文は `result`、再開に使う ID は `session_id`、成否は `is_error` / `subtype` で判定する。
- `jq -r .result` で本文だけ取り出せる。

### stream-json のイベント

1 行 1 イベント。主な `type`:

- `system` (`subtype: "init"`): 開始時。`model`、`cwd`、`session_id` を含む。
- `user`: 入力したプロンプト。
- `thinking`: 思考の途中経過（`subtype: "delta"` / `"completed"`）。
- `assistant`: 回答テキスト。`message.content[].text` に入る。
- `result`: 最後のイベント。`result`、`session_id`、`is_error`、`usage` を含む。

`--stream-partial-output` は `stream-json` と併用したときだけ効き、テキストを差分で流す。途中経過を逐次表示したいときに使う。

## モデル (`--model`)

- 既定は `auto`。モデルを指定するときは `--model <id>`。
- 利用可能な ID は `agent --list-models` で確認する（その時点のアカウントで変わるため、skill には列挙しない）。
- パラメータ付きは引用符で囲んで角括弧に上書き値を書く。例: `--model 'claude-opus-5-thinking-high'`。

## セッションの再開

- `-p` 実行の `session_id`（json の結果、stream-json の `result`）を控える。
- 同じ会話を続けるには `--resume <session_id>` を付ける。直前のコンテキストが引き継がれる（応答の `cacheReadTokens` が増えていれば引き継がれている）。
- 直前のセッションを続けるだけなら `--continue`。
- 対話モードで最新を再開するのは `agent resume`、セッション一覧は `agent ls`。

## 権限と安全性

既定ではファイル変更やシェル実行に承認が要る。`-p` では承認を待てないため、用途に応じて次のどれかを選ぶ。

| やりたいこと | 指定 |
|---|---|
| 読むだけ・提案だけ（変更しない） | `--mode plan`（計画のみ）または `--mode ask`（質問応答のみ） |
| 変更を実際に適用する | `--force`（`--yolo` と同じ）。全コマンドを承認なしで実行する |
| 安全判定を Cursor に任せる | `--auto-review` |

- 既定の流れは `--mode plan` で方針を確かめ、ユーザーの承認後に `--force` で適用する。
- `--force` は承認なしで任意のコマンドを実行する。実行前に対象ディレクトリと内容をユーザーに確認する。
- 作業を隔離したいときは `-w [name]`（`--worktree`）で git worktree に分ける。基点は `--worktree-base <branch>` で指定できる。

## 呼び出し例

```bash
# 読むだけの調査を json で取得
agent -p --output-format json --trust --workspace "$PWD" --mode ask "src/ 配下の認証処理を説明して" | jq -r .result

# 途中経過を追いながら実行
agent -p --output-format stream-json --stream-partial-output --trust --workspace "$PWD" --model auto "README の誤字を直して" \
  | jq -c 'select(.type=="assistant")'

# 前回のセッションに追質問
agent -p --output-format json --trust --workspace "$PWD" --resume "$SESSION_ID" "さっきの説明を 3 行で"
```

## 注意

- 終了コードの仕様は公式に確認できていない。成否は json の `is_error` と `subtype` で判定する。
- 公式ドキュメントと `agent --help` の記述が食い違う箇所（既定の出力形式など）は、実機の `agent --help` を優先する。
