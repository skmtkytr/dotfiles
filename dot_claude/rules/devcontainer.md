---
description: リモート devcontainer 開発環境の詳細
globs:
  - .devcontainer/**
  - config/fish/functions/dev*.fish
---

# 開発環境詳細

## Claude Code の実行場所

**Claude Code はコンテナ内で実行する。** ローカル Mac からではリモートの `/workspace` を直接編集できないため。

```fish
devfish              # コンテナ内 fish シェル (ghq cwd 自動検出)
cd /workspace
claude               # コンテナ内で Claude Code を起動
```

コンテナ内には mise 経由で `claude` がインストール済み。

## コンテナ内の環境

- シェル: **fish** / ワークスペース: `/workspace`
- ツール管理: **mise** (`mise install` で .mise.toml のツールを導入)
- エディタ: neovim (LazyVim ベース)
- GitHub CLI: `gh` (認証は volume で永続化済み)
- パッケージマネージャ: プロジェクトに応じて npm / bun / uv / bundler 等 (mise 経由)

## ローカルからコンテナ内コマンドを実行する (補助的に)

`devexec` は非インタラクティブにコンテナ内コマンドを実行する。

```fish
devexec make test              # テスト実行
devexec cat src/main.rs        # ファイル読み取り
devexec owner/repo npm install # プロジェクト明示指定
```

## その他のコマンド

```fish
devup                          # コンテナ起動 (ghq cwd 自動検出)
devfish                        # コンテナ内 fish シェル (対話的)
devnvimserver owner/repo       # nvim サーバ起動
devup --sync                   # dotfiles 変更をコンテナに反映
devup --remove-existing-container  # コンテナ再作成
devdown owner/repo             # コンテナ削除
devls                          # コンテナ一覧
```

## Git / GitHub 操作

- コンテナ内: `gh` で認証済み。`gh pr create`, `gh issue` 等そのまま使える
- プライベートリポジトリの初回 clone 失敗時: `gh auth login` を実行

## 設定ファイルの場所

コンテナ内の `~/.config` は `~/dotfiles/config` へのシンボリックリンク。
ローカル Mac でも同じ方式 (`~/.config` → `dotfiles/config`)。
`~/.config/` 以下にファイルを置けば自動的にリポジトリ管理対象になる。
