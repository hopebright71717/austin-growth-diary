# 🔄 全面重新部署計劃 — Austin 三台設備 + 兩支手機

> 最後更新：2026-03-23
> 制定人：Austin 徐子凌 + Claude Code

---

## 設備總覽

```
┌──────────────────────────────────────────────────────────────────┐
│                      Austin 指揮中心                              │
│                                                                   │
│  📱 iPhone 15 Pro (512GB)        📸 iPhone 17 Pro (512GB)        │
│  生活工作機                       攝影機                          │
│  Claude App → Remote Control     Claude App → Remote Control      │
│  連線目標 → M1 Pro               連線目標 → M1 Max                │
│  出門遙控營運系統                 出門遙控開發系統                  │
└──────────┬───────────────────────────────────┬───────────────────┘
           │                                    │
  ┌────────▼────────┐   ┌──────────▼──────────┐   ┌───────────────┐
  │  💻 M1 Pro      │   │  🖥️ M1 Max          │   │ 🖥️ Windows    │
  │  16GB RAM       │   │  64GB RAM            │   │ RTX 3070      │
  │  24hr 待命      │   │                      │   │ 24hr 待命     │
  │                 │   │                      │   │               │
  │  📡 營運中心     │   │  🧠 開發中心         │   │ 🎨 生成中心   │
  │                 │   │                      │   │               │
  │ • Threads 自動發文│  │ • ERP v20.2 開發     │   │ • ComfyUI     │
  │ • IGAUTOPOST    │   │ • Life OS v2.0 開發  │   │   port 8188   │
  │   輪播(週4篇)   │   │ • 成長日記維護        │   │ • ACE-Step    │
  │ • IG 限動系統    │   │ • 所有 .md 文件管理  │   │   port 7860   │
  │ • 丁丁嚴選 TG Bot│  │                      │   │               │
  │ • 自動同步 x3   │   │ • 自動同步 x1        │   │ • 純 API 服務 │
  │ • 每日成長日記   │   │                      │   │ • 不主動做事  │
  │ • Remote Control│   │                      │   │               │
  │ • Dispatch 出門用│  │                      │   │               │
  └────────┬────────┘   └──────────────────────┘   └───────┬───────┘
           │                                                │
           └────────── API 呼叫：圖片/音樂生成 ─────────────┘
```

---

## 核心資訊速查

### Austin 個人
- **姓名**：徐子凌（Austin）
- **電話**：0975213758
- **店面**：Q&A 數位蘋果維修中心（台北市萬華區西寧南路36號之92室，近西門捷運站）
- **品牌**：丁丁嚴選

### 收入（月）
| 來源 | 金額 | 備註 |
|------|------|------|
| 驊原（板橋無線電） | ~$35,000 | 月薪扣勞健保，工時自由 |
| 大業欣建設 | $10,000 | 兼差，每週兩天 |
| 蒂納房租 | $6,000 | 老婆印尼朋友，不定時 |
| 租屋補助 | $4,000 | 每月 |
| 二手 3C | 不定 | ERP 追蹤 |
| **合計** | **~$55,000** | |

### GitHub Repos
| Repo | 網址 | 用途 |
|------|------|------|
| austin-erp | github.com/hopebright71717/austin-erp | ERP 系統 |
| austin-growth-diary | github.com/hopebright71717/austin-growth-diary | 成長日記 |
| austin-dingding-bot | github.com/hopebright71717/austin-dingding-bot | 丁丁嚴選 TG Bot |

### Cron 排程
| 電腦 | 時間 | 腳本 | 用途 |
|------|------|------|------|
| M1 Pro | 每 2hr :37 | auto_sync.sh | push 3 個 repo |
| M1 Pro | 每天 3:07 | daily_diary.sh | 生成日記 → GitHub + TG |
| M1 Max | 每 2hr :37 | auto_sync.sh | push Growth Diary |

---

## Phase 0：備份（5 分鐘）

> ⚠️ 清空前一定要先做！

### M1 Pro 備份指令
```bash
# 三個 repo 全部 push
cd ~/Documents/文件\ -\ 徐子凌的MacBook\ Pro/Money_ClaudeCode/ && git add -A && git commit -m "pre-reboot backup $(date +%Y%m%d)" --no-gpg-sign && git push origin main
cd ~/austin-growth-diary && git add -A && git commit -m "pre-reboot backup $(date +%Y%m%d)" --no-gpg-sign && git push origin main
cd ~/DingDing_Copywriter && git add -A && git commit -m "pre-reboot backup $(date +%Y%m%d)" --no-gpg-sign && git push origin main

# 備份 .claude 設定
cp -r ~/.claude ~/.claude_backup_$(date +%Y%m%d)
echo "✅ M1 Pro 備份完成"
```

### M1 Max 備份指令
```bash
cd ~/austin-growth-diary && git add -A && git commit -m "pre-reboot backup $(date +%Y%m%d) [M1Max]" --no-gpg-sign && git push origin main
cp -r ~/.claude ~/.claude_backup_$(date +%Y%m%d)
echo "✅ M1 Max 備份完成"
```

### Windows 備份（手動）
```
1. 複製 C:\Users\xuziling\.claude 到桌面（備份）
2. 確認 ComfyUI 和 ACE-Step 的模型檔案不要動
```

---

## Phase 1：清空所有對話（3 分鐘）

### M1 Pro
1. 所有 Claude Code 終端機輸入 `/exit`
2. 關閉所有終端機視窗
3. 不要關 cron（它是系統層級的，關視窗不影響）

### M1 Max
1. 所有 Claude Code 終端機輸入 `/exit`
2. 關閉所有終端機視窗

### Windows
1. 關閉 Claude Code（如果有開）
2. 不要關 ComfyUI 和 ACE-Step 服務

---

## Phase 2：Windows 清理舊 Remote Control（2 分鐘）

### 給到 Windows 的指令
```
🎯 目標：清理 Claude App 裡的舊 Remote Control session

📌 現在做

📝 步驟：
1. 找到 .claude 目錄（C:\Users\xuziling\.claude\）
2. 列出裡面所有檔案和資料夾
3. 只刪除 session 相關檔案（.jsonl 檔案）
4. 絕對不要刪除：
   - CLAUDE.md 和所有 .md 檔案
   - settings.json
   - memory/ 目錄
   - projects/ 目錄
5. 絕對不要動：
   - ComfyUI 的任何檔案和模型
   - ACE-Step 的任何檔案和模型
   - Stable Diffusion 的任何檔案

回報：刪除了哪些檔案、保留了哪些檔案。
```

---

## Phase 3：重新部署三台設備（15 分鐘）

### 💻 M1 Pro — 📡 營運中心

#### 開新終端，啟動 Claude Code：
```bash
cd ~/Documents/文件\ -\ 徐子凌的MacBook\ Pro/Money_ClaudeCode/
claude
```

#### 貼入啟動指令：
```
🎯 角色：你是 Austin 的營運自動化中心（M1 Pro · 16GB · 24hr 待命）

## 你負責的系統
1. **Threads 自動發布** — 自動排程貼文
2. **IGAUTOPOST** — IG 輪播貼文（一週四篇），需調用 Windows 生成圖片
3. **IG 限時動態** — 每天發布，用照片+浮水印+音樂，以 Reel 呈現
4. **丁丁嚴選 TG Bot** — @dingding_copy_bot，幫客戶生成上架文案
5. **自動同步** — 每 2 小時 push 三個 GitHub repo（已設好 cron）
6. **每日成長日記** — 凌晨 3:07 自動生成（已設好 cron）
7. **Remote Control** — 讓 Austin 用 iPhone 15 Pro 遠端操控

## 外部 API 資源
- Windows ComfyUI 圖片生成: http://[WINDOWS_IP]:8188
- M1 Max ACE-Step 音樂生成: http://192.168.0.3:7860

## 專案位置
- ERP: ~/Documents/文件 - 徐子凌的MacBook Pro/Money_ClaudeCode/
- 丁丁嚴選: ~/DingDing_Copywriter/
- 成長日記: ~/austin-growth-diary/

## Threads API 開發方向
- 閱讀官方 API 文件，將所有可用功能都實作
- 自動排程發文、互動回覆、數據分析

## IGAUTOPOST 開發方向
- 輪播貼文：一週四篇，品質優先
- 限時動態：每天發布，串接 TG 接收照片 → 壓字+浮水印+音樂 → 發布
- 圖片：呼叫 Windows ComfyUI API
- 音樂：呼叫 M1 Max ACE-Step API

## 工作模式
- 24 小時待命
- Austin 出門時透過 iPhone 15 Pro Remote Control 下達指令
- 接收到指令就執行，完成後回報

請確認：
1. crontab -l 顯示兩個排程
2. 所有專案目錄存在
3. git status 三個 repo 都乾淨
然後回報系統狀態。
```

#### 另開新終端，啟動 Remote Control：
```bash
claude remote-control --name "M1Pro-營運中心"
```

---

### 🖥️ M1 Max — 🧠 開發中心

#### 開新終端，啟動 Claude Code：
```bash
cd ~/austin-growth-diary
claude
```

#### 貼入啟動指令：
```
🎯 角色：你是 Austin 的系統開發中心（M1 Max · 64GB RAM）

## 你負責的系統
1. **ERP v20.2**（二手 Apple 3C 買賣系統）
   - 位置: 需 git clone https://github.com/hopebright71717/austin-erp.git（如果本地沒有）
   - 技術: Vue 3 + Tailwind CSS + Firebase + localStorage
   - 最近完成: 14 項安全+財務修復（v20.2）

2. **Life OS v2.0**（人生管理系統）
   - 位置: 在 ERP 同目錄下的 life.html
   - 模組: 財務總覽、待辦事項、資產管理、技能樹
   - 設計哲學: 極簡、人類直覺、AI 可操作、自我防護

3. **成長日記**
   - 位置: ~/austin-growth-diary/
   - 自動同步: 每 2 小時 push（cron 已設好）

## 設計三原則
1. **人類直覺** — 打開就知道該做什麼，不需要思考 UI
2. **AI 直覺** — 每個元素有語意化 data-* 屬性，Claude 讀 DOM 就能操作
3. **自我防護** — try-catch + 錯誤日誌 + 健康檢查 + 自動修復

## 工作模式
- Austin 在 Claude Chat（這個視窗）討論需求和設計
- 討論好後，Austin 把具體指令貼到終端機讓你執行
- 你只負責寫程式碼和維護系統，不做營運工作
- Austin 是老闆，你是助理：他說話+審閱，你操作+維護

## Austin 的財務資料（Life OS 用）
- 月收入: ~$55,000（驊原$35K + 大業欣$10K + 蒂納房租$6K + 補助$4K）
- 固定支出: 15 筆帳單（已匯入 Life OS）
- 年度保險: 3月凱基$26,820 / 8月富邦$22,276 / 9月台灣+全球$69,051
- 車貸 2026/03 已繳清 🎉

請確認：
1. crontab -l 顯示排程
2. austin-growth-diary repo 存在且乾淨
3. 回報系統狀態
```

---

### 🖥️ Windows — 🎨 生成中心

#### 給到 Windows 的指令（清理完 session 後）：
```
🎯 角色：你是 Austin 的 AI 內容生成中心（Windows · RTX 3070 · 24hr 待命）

## 你負責的服務
1. **ComfyUI**（圖片生成）
   - Port: 8188
   - 用途: M1 Pro 的 IGAUTOPOST 呼叫你生成配圖
   - 必須確保 API 對區域網路開放

2. **ACE-Step 1.5**（音樂生成，如果有安裝）
   - Port: 7860
   - 用途: M1 Pro 的 IG 限動需要背景音樂
   - 備註: M1 Max 也有裝 ACE-Step 作為備援

## 工作模式
- 純 API 服務模式，24 小時待命
- 不主動做事，等 M1 Pro 呼叫
- 確保服務穩定不掛掉

## 任務
1. 確認 ComfyUI 正在運行（port 8188 可存取）
2. 回報這台電腦的區域網路 IP
3. 回報 GPU 狀態（nvidia-smi）

請回報服務狀態。
```

---

## Phase 4：驗證（5 分鐘）

| # | 驗證項目 | 指令/方法 | 預期結果 |
|---|---------|----------|---------|
| 1 | M1 Pro Claude Code | 終端輸入 `/version` | 顯示版本號 |
| 2 | M1 Pro Cron | `crontab -l` | 兩個排程（:37 同步 + 3:07 日記）|
| 3 | M1 Pro Remote Control | iPhone 15 Pro Claude App 連線 | 成功連上 |
| 4 | M1 Pro Git | `git status`（三個 repo） | 全部 clean |
| 5 | M1 Max Claude Code | 終端輸入 `/version` | 顯示版本號 |
| 6 | M1 Max Cron | `crontab -l` | 一個排程（:37 同步）|
| 7 | M1 Max ACE-Step | `curl http://localhost:7860` | 回應正常 |
| 8 | Windows ComfyUI | `curl http://[WIN_IP]:8188/system_stats` | 回應 JSON |
| 9 | Windows 舊 session | Claude App 檢查 | 封存紀錄已消失 |
| 10 | TG 頻道 | 手動 curl 測試 | @Xuzilin 收到訊息 |

---

## 執行時間線

```
分鐘 0-5    Phase 0  備份（三台電腦 git push + .claude 備份）
分鐘 5-8    Phase 1  清空（所有終端 /exit → 關閉視窗）
分鐘 8-10   Phase 2  Windows 清理舊 session
分鐘 10-25  Phase 3  重新部署（三台各貼啟動指令）
分鐘 25-30  Phase 4  驗證（10 項檢查）

✅ 30 分鐘完成全面重新部署
```

---

## 日常運作流程

### 在家工作
```
Austin 坐在電腦前
├→ M1 Max Claude Chat：討論需求、設計功能
├→ M1 Max 終端 Claude Code：執行開發指令
├→ M1 Pro 自動跑：Threads、IGAUTOPOST、同步
└→ Windows 自動跑：圖片/音樂 API
```

### 出門在外
```
Austin 只帶兩支手機
├→ iPhone 15 Pro → Remote Control → M1 Pro
│   「檢查 Threads 發文狀態」
│   「IGAUTOPOST 生成今天的輪播」
│   「幫我整理一下待辦事項」
│
├→ iPhone 17 Pro → Remote Control → M1 Max
│   「ERP 加一個新功能」
│   「Life OS 更新我的技能樹」
│   「幫我找電腦裡的那份報價單」
│
└→ 三台電腦 24hr 自動運行
    • 每 2 小時自動 push
    • 凌晨 3:07 自動生成日記
    • Windows 持續提供圖片/音樂 API
```

### 睡覺時
```
凌晨 2:37  M1 Pro + M1 Max 自動 push 最後一次
凌晨 3:07  M1 Pro 自動生成成長日記 → push GitHub → 發 TG @Xuzilin
早上起床   打開 TG → 看到昨天的成長紀錄 📱
```

---

*此計劃由 Austin 徐子凌 與 Claude Code 共同制定*
*檔案位置：~/austin-growth-diary/FULL_REBOOT_PLAN.md*
