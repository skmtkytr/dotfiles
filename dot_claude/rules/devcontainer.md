---
description: mono-local devcontainer 開発環境の詳細
globs:
  - .devcontainer/**
  - dot_config/fish/user_functions/dev*.fish
---

# 開発環境詳細 (mono-local devcontainer)

## 概要

CachyOS デスクトップ + macOS の併用、両方とも **local docker** で
**mono-local devcontainer** を1つ起動して使う。
GHCR の prebuilt image や remote docker は使わない。

```fish
devup            # コンテナ起動 (初回は build)
devfish          # コンテナ内 fish シェル
devdown          # コンテナ削除 (volume も削除)
```

## bind mount 構成

| host path | container path | 用途 |
|---|---|---|
| `~/.ghq` | `/home/vscode/.ghq` | プロジェクトリポジトリ |
| `~/.local/share/chezmoi` | `/home/vscode/.local/share/chezmoi` | dotfiles ソース (chezmoi が直接参照) |

加えて以下は **named volume** (永続化、ホストファイルとは独立):

- `~/.local/share/{mise,nvim,fish,tmux}` — 各ツールのプラグイン/インストール状態

## SSH agent (1Password)

ホストの 1Password SSH agent は TCP socat bridge 経由で container に流す。
ホスト側で `~/.ssh/agent.sock` symlink (chezmoi 管理、OS別) を維持していれば、
`devup` が自動で `socat TCP-LISTEN:12345 ... agent.sock` を立てる。
container 内では fish 起動時に `~/.local/bin/ssh-agent-bridge.sh` が
container 側 unix socket を立て、`SSH_AUTH_SOCK` 経由で透過的に使える。

## dotfiles の編集ワークフロー

1. ホストで `~/.local/share/chezmoi/dot_config/...` を編集
2. ホストで `chezmoi apply` (host の `~/.config` に反映)
3. コンテナ内に反映するには `devup --sync` (= container 内 `chezmoi apply`)
   または `devexec chezmoi apply`

bind mount により container は常に最新の source を見ているので、
編集した瞬間 source は最新だが、deploy はコマンド明示が必要。

## コマンド一覧

```fish
devup                            # 起動
devup --sync                     # コンテナ内 chezmoi apply 再実行
devup --remove-existing-container # 再作成
devup --rebuild-no-cache         # image 再build
devfish                          # コンテナ内 fish (cwd ミラー)
devfish /home/vscode/.ghq/...    # 明示パスで入る
devexec <command...>             # 非対話実行 (mise shims on PATH)
devnvimserver [port]             # headless nvim 起動 (host network なので proxy 不要)
devport <port>                   # URL 表示 (host network なので forward 不要)
devscp <local> [container]       # ファイル copy
devls                            # 状態表示
devdown                          # 削除 + volume 削除
devdown --keep-volumes           # 削除するが volume は残す
```

## Claude Code

Claude Code は **ホスト側で実行** する (container 内で動かす必要は無い)。
container 内のセッションログを集約したい場合は `ccusage-sync` で同期可能。

## Git / GitHub

container 内の `gh` は volume 永続化されていない (mono-local では gh config volume を持たない)。
初回 container では `gh auth login` を実行する必要がある。
ssh signing は SSH agent bridge 経由でホストの 1Password で署名される。
