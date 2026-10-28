#!/bin/bash
# UserPromptSubmit: Claude Desktop のサイドバーで作業中と分かるよう、セッションタイトルの先頭の状態アイコンを 🔵 にする
title=$(jq -r '.session_title // empty')
[ -z "$title" ] && exit 0

for icon in 🔵 🔴 🟡 🟢 ⚪️; do
  title=${title#"$icon "}
done

jq -n --arg t "🔵 $title" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", sessionTitle: $t}}'
