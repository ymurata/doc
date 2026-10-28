@~/.claude/AGENTS.md

## サブエージェントのモデル
親のモデルごとに、依頼できるサブエージェントのモデルを次のとおりにする。

- opus: opus、sonnet、haiku
- sonnet: sonnet、haiku
- haiku: haiku

自分より上位のモデルのサブエージェントは起動しない。

## Claude Code
- 設定や memory の棚卸しは `/doctor prompt-audit` と `/memory` で行う

## Claude Desktop
- Code タブのサイドバーは状態別に表示している。ユーザーの操作 (レビュー、PR のマージ、承認、選択) を待って止まるときは、`wrap_up` の `ask` と `blocked: true` で依頼し、入力待ちとして表示させる
