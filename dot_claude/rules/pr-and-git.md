---
description: PR 運用と Git コミットのルール
globs:
  - .github/**
---

# PR 運用

- **push したら必ず PR を作成する（言われる前に自動で）**
- **コード変更には必ずテストを書く**
- 別ブランチから新ブランチを切るときは master から切る
- PR 作成したら `gh pr view --json mergeable` でコンフリクト確認
- コンフリクトがあれば master をマージして解消してから push

# Git コミット

- コミットは明示的に依頼されたときだけ行う
- 動作確認が済んでいないものを commit push しない
- コミットメッセージは英語
- コミットメッセージに Co-Authored-By を付けない
