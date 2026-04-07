# dotfiles

[chezmoi](https://www.chezmoi.io/) managed dotfiles.

## Bootstrap a new machine

```sh
sh -c "$(curl -fsSL https://chezmoi.io/get)" -- init --apply skmtkytr/dotfiles
```

This installs `chezmoi`, clones this repository, and applies it to `$HOME`.

## Layout

| Path | Deployed to | Notes |
|---|---|---|
| `dot_config/` | `~/.config/` | アプリケーション設定 |
| `dot_claude/` | `~/.claude/` | Claude Code 設定 (CLAUDE.md, settings, commands, hooks, rules) |
| `private_dot_ssh/` | `~/.ssh/` | mode 700 |
| `run_once_*.sh.tmpl` | (executed) | 初回 apply 時に1度だけ実行されるプロビジョニングスクリプト |
| `.devcontainer/` | — (chezmoi 管理外) | mono-local devcontainer 定義 (Dockerfile / devcontainer.json / setup.sh) |
| `.chezmoiignore.tmpl` | — | OS別の除外宣言 |
| `.chezmoidata.toml` | — | テンプレ変数 |

## Conventions

- **OS branching**: `{{ if eq .chezmoi.os "darwin" }} ... {{ end }}` をテンプレ内で使用
- **Secrets**: `{{ onepasswordRead "op://Vault/Item/field" }}` で 1Password から取得
- **Feature flags**: `.chezmoidata.toml` の `[features]` セクションで宣言。
  `secrets_available` (1Password 利用可) / `in_devcontainer` (container 内で apply されているか) を
  `~/.config/chezmoi/chezmoi.toml` の `[data.features]` で上書き可能。
- **Out of scope**: `~/.claude/projects/*/memory/` はランタイム書き込みのため chezmoi 管理外。
  必要なら `~/.claude/CLAUDE.md` にサマリして永続化する運用。

## Devcontainer (mono-local)

CachyOS デスクトップ + macOS 両用、local docker 専用の単一 mono-local devcontainer。
詳細は `dot_claude/rules/devcontainer.md` 参照。

```fish
devup            # コンテナ起動 (初回は build)
devfish          # コンテナ内 fish (cwd ミラー)
devup --sync     # コンテナ内で chezmoi apply 再実行
devdown          # コンテナ + named volumes 削除
```

bind-mount 構成:

| host | container | 用途 |
|---|---|---|
| `~/.local/share/chezmoi` | 同じ | dotfiles ソース (chezmoi が直接参照) |
| `~/.ghq` | 同じ | プロジェクトリポジトリ |
