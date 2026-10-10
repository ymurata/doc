---
name: antigravity-cli
description: Antigravity CLI（`agy` コマンド）を別プロセスやスクリプトから非対話（`-p`）で呼び出す手順。出力形式、モデル指定、会話の継続、権限モードの選び方を扱う。「agy で実行」「antigravity cli で質問」「agy -p」「antigravity でファイルを変更」「前の agy 会話を続けて」「agy の stream-json を解析」など、Antigravity の CLI を使う場面では必ずこの skill を使う。Antigravity エディタ本体の操作だけの話では使わない。
---

# Antigravity CLI (`agy`)

作業を始める前に `agy --help` を実行し、フラグの仕様を確認する。フラグの詳細はこの skill に書かず、ここには呼び出しの型と既定値だけを書く。

## 既定の呼び出し

ユーザーが指定しない限り、次の形で実行する。

```bash
agy --output-format json -p "<プロンプト>"
```

- `--output-format json`: 結果を 1 つの JSON で受け取る。`jq -r .response` で本文を取り出す。
- `-p "<プロンプト>"`: 非対話で実行する。`-p` は直後の引数をプロンプトとして読むため、`--output-format` などのフラグは `-p` より前に置く。誤って後ろに置くと `-p took "--output-format" as its prompt` で失敗する。
- `--mode` は未指定: 質問への回答や読み取りはできるが、ファイルの書き込みとコマンド実行は自動で拒否される（`denied_actions` に記録される）。
- `--model` は未指定: CLI の既定モデルを使う。モデル一覧は `agy models` で確認し、指定する場合のみ付ける。
- `--print-timeout` は未指定（既定 `0`）: ターンが終わるまで待つ。

## 権限モード

ヘッドレスでは権限の確認に答えられないため、必要な権限は事前に与える。

- ファイルを作成・編集させる場合: `--mode accept-edits` を付ける。書き込みは通るが、コマンド実行は拒否される。
- コマンド実行も必要な場合: `--dangerously-skip-permissions` を付ける。全ツールを確認なしで実行するため、対象ディレクトリと内容をユーザーに確認してから使う。
- `--mode plan` は読み取り専用として使わない。単純な質問でもコマンド実行を試みて空の応答になることを確認した。計画を作成してファイルを残すため、副作用もある。

どの権限モードでも、`denied_actions` が `null` でない場合は拒否された操作があるため、結果を信用せず再実行を検討する。

## 結果の読み方

- 成否: `status` が `SUCCESS` か確認する。`response` が空の場合は `denied_actions` を見る。
- 本文: `response`。
- 会話の ID: `conversation_id`。
- stream-json は 1 行 1 イベントで、`event` フィールドで種類を判別する。`init`（`conversation_id` を含む）、`step_update`（`step_type`、`state`、`text_delta` を含む途中経過）、`result`（`response`、`status`、`usage` を含む最終結果）の順に出る。最終結果は `select(.event=="result") | .result` で取り出す。

## 会話の継続

同じ会話を続けるには、前回の `conversation_id` を `--conversation <id>` で渡す。直前の文脈が引き継がれることを確認済み。`--continue`（`-c`）は直近の会話を続ける。

```bash
agy --output-format json --conversation "<conversation_id>" -p "<続けるプロンプト>"
```

## 詳細の確認

フラグの組み合わせや細かな仕様は `agy --help` で確認する。利用可能なモデルは `agy models` で確認する。モデル ID はアカウントによって変わるため、skill には列挙しない。
