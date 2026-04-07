# Global Instructions

## Preferences

- 日本語でコミュニケーション
- コミットメッセージは英語 / Co-Authored-By 不要
- コミットは明示的に依頼されたときだけ（未検証のものは push しない）

## Tech Stack

| Layer | Tool |
|-------|------|
| Shell | fish |
| Editor | neovim (LazyVim) |
| Tool管理 | mise |
| GitHub CLI | gh |
| Container | devcontainer (mono-local, local docker) |
| Config管理 | chezmoi (source: `~/.local/share/chezmoi`) |

## 開発環境

CachyOS デスクトップ + macOS の併用。両方とも local docker で mono-local devcontainer
を起動して使う (`devup` で起動、`devfish` で入る)。

dotfiles は chezmoi で管理。コンテナ内では `~/.local/share/chezmoi` を bind-mount し、
コンテナ起動時に `chezmoi apply` で `~/.config` 配下を展開する。`~/.ghq` も bind-mount
されているのでホストのプロジェクトリポジトリにそのままアクセスできる。

詳細は `.claude/rules/devcontainer.md` 参照。

## 行動原則（常に守ること）

1. **調査が先**: 変更対象と関連ファイルを必ず読んでから着手
2. **テスト駆動**: RED → GREEN → エッジケース追加
3. **削除時は Grep**: リネーム・削除したら参照を全体検索、残があれば修正
4. **品質ゲート**: lint/型チェック エラー0、テスト全pass、既存テストは消さない
5. **commit は最後**: 全ゲート通過後にのみ commit。push 後は CI 確認
6. **PR は自動作成**: push したら言われる前に PR を作る。テスト必須
