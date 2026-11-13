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
- Code タブのサイドバーは作業フォルダー別のセクションに分ける
- セッションの最初のターンで、自分を作業フォルダーのセクションへ `move_sessions` (`self`) で移す。セクション名は作業フォルダーの `~/repos/` からの相対パス (例: `dxc/saas_prj`) で、worktree (`<フォルダー>/.claude/worktrees/<名前>`) は元のフォルダー名を使う。`list_sections` に無ければ `create_section` で作る
