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
7. **推測を断定するな**: 観察事実（ログ・コード・出力）と推論を必ず分けて伝える。因果・メカニズムの断言はコード/公式ドキュメントで確認できた場合のみ。確認できていない場合は「可能性がある（根拠：X）」「仮説：〜、検証するには〜」と書く

## 環境固有の注意

- **1Password transient failure**: `chezmoi apply` や `git commit` で "Could not connect to socket" が出たらまず同じコマンドをリトライ。環境の問題ではなく 1Password 側の一時的な IPC 競合。リトライで通常解決する。
