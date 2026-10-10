@~/.claude/AGENTS.md

## サブエージェントのモデル
親のモデルごとに、依頼できるサブエージェントのモデルを次のとおりにする。

- opus: opus、sonnet、haiku
- sonnet: sonnet、haiku
- haiku: haiku

自分より上位のモデルのサブエージェントは起動しない。

## Claude Code
- 設定や memory の棚卸しは `/doctor prompt-audit` と `/memory` で行う
