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
- Code タブのサイドバーは作業フォルダー別のセクションに分け、状態はセッションタイトル先頭のアイコンで示す。作業中の 🔵 はプロンプト送信時に hook が付ける
- セッションの最初のターンで、自分を作業フォルダーのセクションへ `move_sessions` (`self`) で移す。セクション名は作業フォルダーの `~/repos/` からの相対パス (例: `dxc/saas_prj`) で、worktree (`<フォルダー>/.claude/worktrees/<名前>`) は元のフォルダー名を使う。`list_sections` に無ければ `create_section` で作る
- ターンを終えるときは、`set_session_title` (`self`) でタイトル先頭の状態アイコンを次のいずれかに付け替える。アイコン以外のタイトルは変えない
  - 🔴 入力待ち: ユーザーの操作 (承認、選択、PR のマージ) を待って止まる。`wrap_up` の `ask` と `blocked: true` でも依頼する
  - 🟡 PR レビュー待ち: PR を作成し、レビューを待つ
  - 🟢 完了: 依頼を終え、待っているものがない
  - ⚪️ 失敗 (U+26AA U+FE0F): エラーやテストの失敗で作業を続けられない
