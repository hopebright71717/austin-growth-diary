# 📔 Austin 成長日記

自動記錄每日學習與系統開發進度，打造個人成長軌跡。

## 📋 簡介

Austin 成長日記是一套自動化的每日記錄系統，透過 Shell 腳本自動生成當日日記模板、記錄開發進度與學習心得，並自動同步至 GitHub。搭配完整的設備重新部署計劃，涵蓋三台電腦 + 兩支手機的工作流程規劃。

## 🚀 功能

- **每日自動日記** — Shell 腳本自動生成當日 Markdown 日記
- **自動同步** — 定時 git commit + push 至 GitHub
- **設備部署計劃** — 三台電腦（M1 Pro / M1 Max / Windows）完整架構規劃
- **開發進度追蹤** — 記錄各專案開發里程碑

## 🛠️ 技術棧

| 技術 | 用途 |
|------|------|
| Shell Script | 自動化腳本 |
| Markdown | 日記格式 |
| Git + GitHub | 版本控制與同步 |
| Cron | 定時排程 |

## 📁 專案結構

```
austin-growth-diary/
├── diary/              # 每日日記（按日期命名）
├── scripts/
│   ├── daily_diary.sh  # 每日日記生成腳本
│   └── auto_sync.sh    # 自動同步腳本
├── FULL_REBOOT_PLAN.md # 全面重新部署計劃
└── README.md
```

## 🚀 使用方式

```bash
# 生成今日日記
./scripts/daily_diary.sh

# 自動同步至 GitHub
./scripts/auto_sync.sh
```

## 👤 作者

**Austin（徐子凌）**
