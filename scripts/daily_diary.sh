#!/bin/bash
# ============================================
# Austin 成長日記 — 每日自動生成腳本
# 由 M1 Pro cron 每天凌晨 3:00 執行
# ============================================

set -e

# === 設定 ===
DIARY_DIR="$HOME/austin-growth-diary"
ERP_DIR="$HOME/Documents/文件 - 徐子凌的MacBook Pro/Money_ClaudeCode"
TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%A)
DIARY_FILE="$DIARY_DIR/diary/${TODAY}.md"
TG_BOT_TOKEN="7927770177:AAHi5AKKxG6oGPCi7eQNIlmkUBJKvfHVhqQ"
TG_CHANNEL="@Xuzilin"
LOG_FILE="$DIARY_DIR/scripts/diary.log"

# === 中文星期 ===
case $DAY_OF_WEEK in
  Monday) ZH_DAY="週一";;
  Tuesday) ZH_DAY="週二";;
  Wednesday) ZH_DAY="週三";;
  Thursday) ZH_DAY="週四";;
  Friday) ZH_DAY="週五";;
  Saturday) ZH_DAY="週六";;
  Sunday) ZH_DAY="週日";;
esac

echo "[$(date)] 開始生成日記..." >> "$LOG_FILE"

# === 收集 Git 變更 ===
cd "$ERP_DIR"
git fetch origin 2>/dev/null || true
ERP_CHANGES=$(git log --since="yesterday" --oneline 2>/dev/null || echo "無變更")
ERP_FILES=$(git diff --stat HEAD~1 2>/dev/null | tail -1 || echo "無")
ERP_DIFF_SUMMARY=$(git diff --stat HEAD~1 2>/dev/null | head -20 || echo "")

# === 讀取 ROADMAP 完成項目 ===
COMPLETED=$(grep -c "\[x\]" "$ERP_DIR/ROADMAP.md" 2>/dev/null || echo "0")
PENDING=$(grep -c "\[ \]" "$ERP_DIR/ROADMAP.md" 2>/dev/null || echo "0")

# === 讀取今天的待辦（如果 Life OS 有資料）===
# 未來可以擴展讀取 localStorage export

# === 計算天數（從 2025-02-23 開始，Austin 開始 AI 學習的日子）===
START_DATE="2025-02-23"
DAYS_SINCE=$(( ( $(date -j -f "%Y-%m-%d" "$TODAY" +%s 2>/dev/null || date -d "$TODAY" +%s) - $(date -j -f "%Y-%m-%d" "$START_DATE" +%s 2>/dev/null || date -d "$START_DATE" +%s) ) / 86400 ))

# === 用 claude -p 生成日記內容 ===
PROMPT="你是 Austin 徐子凌的成長日記助手。請根據以下資訊生成今天的成長日記。

日期: $TODAY ($ZH_DAY)
AI 學習第 $DAYS_SINCE 天

ERP 最近變更:
$ERP_CHANGES

檔案變動:
$ERP_DIFF_SUMMARY

ROADMAP 進度: $COMPLETED 項已完成 / $PENDING 項待辦

請用以下格式生成（繁體中文）:

# 🗓️ Day $DAYS_SINCE — $TODAY $ZH_DAY

## 今日進展
（根據 git 變更列出 3-5 個重點，如果沒有變更就寫「休息日」）

## 技術筆記
（從變更中提取 1-2 個技術學習重點）

## 反思
（一句話鼓勵自己）

---
*自動生成 by Austin Growth Diary System*"

# 生成日記
mkdir -p "$DIARY_DIR/diary"
claude -p "$PROMPT" > "$DIARY_FILE" 2>/dev/null

# === 如果 claude 失敗，寫基本日記 ===
if [ ! -s "$DIARY_FILE" ]; then
  cat > "$DIARY_FILE" << FALLBACK
# 🗓️ Day $DAYS_SINCE — $TODAY $ZH_DAY

## 今日進展
$ERP_CHANGES

## 檔案變動
$ERP_DIFF_SUMMARY

## 進度
- 已完成: $COMPLETED 項
- 待辦: $PENDING 項

---
*自動生成 by Austin Growth Diary System*
FALLBACK
fi

# === 推送到 GitHub ===
cd "$DIARY_DIR"
git add -A
git commit -m "diary: $TODAY (Day $DAYS_SINCE)" 2>/dev/null || true
git push origin main 2>/dev/null || true

# === 發送到 TG 頻道 ===
# 讀取日記內容（限制 4096 字元）
TG_MSG=$(head -c 4000 "$DIARY_FILE")

curl -s -X POST "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TG_CHANNEL}" \
  -d parse_mode="Markdown" \
  --data-urlencode "text=${TG_MSG}" \
  > /dev/null 2>&1 || echo "[$(date)] TG 發送失敗" >> "$LOG_FILE"

echo "[$(date)] 日記生成完成: $DIARY_FILE" >> "$LOG_FILE"
echo "[$(date)] Day $DAYS_SINCE 🎉" >> "$LOG_FILE"
