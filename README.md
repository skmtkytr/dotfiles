# dotfiles-v2

[chezmoi](https://www.chezmoi.io/) managed dotfiles.
Migration target from [`skmtkytr/dotfiles`](https://github.com/skmtkytr/dotfiles).

## Bootstrap a new machine

```sh
sh -c "$(curl -fsSL https://chezmoi.io/get)" -- init --apply skmtkytr/dotfiles-v2
```

This installs `chezmoi`, clones this repository, and applies it to `$HOME`.

## Layout

| Path | Deployed to | Notes |
|---|---|---|
| `dot_config/` | `~/.config/` | アプリケーション設定 |
| `dot_claude/` | `~/.claude/` | Claude Code 設定 (CLAUDE.md, settings, commands, hooks, rules) |
| `private_dot_ssh/` | `~/.ssh/` | mode 700 |
| `run_once_*.sh.tmpl` | (executed) | 初回 apply 時に1度だけ実行されるプロビジョニングスクリプト |
| `.chezmoiignore.tmpl` | — | OS別の除外宣言 |
| `.chezmoidata.toml` | — | テンプレ変数 |

## Conventions

- **OS branching**: `{{ if eq .chezmoi.os "darwin" }} ... {{ end }}` をテンプレ内で使用
- **Secrets**: `{{ onepasswordRead "op://Vault/Item/field" }}` で 1Password から取得
- **Out of scope**: `~/.claude/projects/*/memory/` はランタイム書き込みのため chezmoi 管理外。
  必要なら `~/.claude/CLAUDE.md` にサマリして永続化する運用。

## Migration status

WIP. See `docs/migration.md` for the plan and progress.
