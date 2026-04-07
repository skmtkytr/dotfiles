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
| Container | devcontainer (remote) |
| Config管理 | `~/.config` → `dotfiles/config` symlink |

## 開発環境

リモート devcontainer 上で開発。ローカル Mac はターミナル + nvim client のみ。
**Claude Code はコンテナ内で実行する。** 詳細は `.claude/rules/devcontainer.md` 参照。

## 行動原則（常に守ること）

1. **調査が先**: 変更対象と関連ファイルを必ず読んでから着手
2. **テスト駆動**: RED → GREEN → エッジケース追加
3. **削除時は Grep**: リネーム・削除したら参照を全体検索、残があれば修正
4. **品質ゲート**: lint/型チェック エラー0、テスト全pass、既存テストは消さない
5. **commit は最後**: 全ゲート通過後にのみ commit。push 後は CI 確認
6. **PR は自動作成**: push したら言われる前に PR を作る。テスト必須
