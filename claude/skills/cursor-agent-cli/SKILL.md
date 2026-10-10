---
name: cursor-agent-cli
description: Cursor CLI（`agent` コマンド）を別プロセスやスクリプトから非対話（`-p`）で呼び出す手順。出力形式、モデル指定、セッション再開、権限の選び方を扱う。「cursor agent で実行」「agent -p」「cursor cli でコードを変更」「cursor のモデルで質問」「前の cursor セッションを再開」「stream-json を解析」など、Cursor の agent CLI を使う場面では必ずこの skill を使う。Cursor エディタ本体の操作や Cursor のルール設定だけの話では使わない。
---

# Cursor CLI (`agent`)

作業を始める前に `agent --help` を実行し、フラグの仕様を確認する。フラグの詳細はこの skill に書かず、ここには呼び出しの型と既定値だけを書く。

## 既定の呼び出し

ユーザーが指定しない限り、次の形で実行する。

```bash
agent -p --output-format json --trust --workspace "$PWD" --model auto --mode ask "<プロンプト>"
```

- `-p`: 非対話で実行する。付けないと TUI が起動し、スクリプトではハングする。
- `--output-format json`: 結果を 1 つの JSON で受け取る。`jq -r .result` で本文を取り出す。
- `--trust --workspace "$PWD"`: 信頼確認で止まらないよう、作業ディレクトリを明示する。
- `--model auto`: モデルを指定しない場合の既定。
- `--mode ask`: 読み取り専用。ファイルを変更させない。

ユーザーがファイルの変更を求めた場合だけ `--mode ask` を外し、`--force`（`--yolo` と同じ）を付ける。`--force` は確認なしで任意のコマンドを実行するため、実行前に対象ディレクトリと内容をユーザーに確認する。

## 結果の読み方

- 成否: `is_error` と `subtype` で判定する。終了コードは使わない。
- 本文: `result`。
- 再開用 ID: `session_id`。
- stream-json は 1 行 1 イベント。途中経過は `assistant`（`message.content[].text`）、最後は `result` で受け取る。途中経過を逐次扱うときは `--stream-partial-output` を併用する。

## セッションの再開

同じ会話を続けるには、前回の `session_id` を `--resume <session_id>` で渡す。直前の文脈が引き継がれる。直前の会話をそのまま続けるだけなら `--continue`。

## 詳細の確認

利用可能なモデルは `agent models` で確認する。モデル ID はアカウントによって変わるため、skill には列挙しない。認証は `agent status` で確認し、未ログインなら `agent login` をユーザーに案内する。
