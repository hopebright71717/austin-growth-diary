#!/bin/bash
# ============================================
# 自動同步腳本 — 每 2 小時檢查變更並推送
# ============================================

LOG="$HOME/austin-growth-diary/scripts/sync.log"

sync_repo() {
  local DIR="$1"
  local NAME="$2"

  if [ ! -d "$DIR/.git" ]; then return; fi

  cd "$DIR"

  # 檢查是否有變更
  if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
    return  # 沒有變更，跳過
  fi

  # 自動 commit + push
  git add -A
  git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M') $NAME" --no-gpg-sign 2>/dev/null
  git push origin main 2>/dev/null

  echo "[$(date)] ✅ $NAME 已同步" >> "$LOG"
}

# === 同步所有專案 ===
sync_repo "$HOME/Documents/文件 - 徐子凌的MacBook Pro/Money_ClaudeCode" "ERP"
sync_repo "$HOME/austin-growth-diary" "Growth Diary"
sync_repo "$HOME/DingDing_Copywriter" "丁丁嚴選"
