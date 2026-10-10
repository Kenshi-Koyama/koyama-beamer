# 変更履歴

版は `_extensions/econ/_extension.yml` の `version`。

## 1.0.0（2026-10-10）

各研究に散らばっていたプリアンブルとルールを、このリポジトリに一本化した最初の版。

- Quarto の拡張機能にした（`format: econ-beamer`）。`quarto use template` / `quarto add` で各デッキに入れる
- YAML の切り替えオプションを追加
  - `section-outline: false`：各セクション冒頭の Outline を入れない（短い発表用）
  - `bib-file:`：文献ファイルの指定（既定 `ref.bib`）
- 部品を追加：`\srcite{key}`（箇条書き項目の出典）、`\tinynote{...}`（`\slidenote` より小さい注）
- 見本（`template.qmd`）を公開できる架空の例に差し替え、廃止した `\alert` を使わない書き方にそろえた
- 文書を `docs/` に整理：SlideRules（デザイン）、workflow（進め方）、recipes（応用）、setup（環境構築）
- 図をスライドの実寸で作るルールを SlideRules の 7. に追加（幅 4.25 インチ・300dpi・軸 8.5pt など）

## 1.0.0 より前の経緯

- 2026-07：Overleaf の Beamer 手書きから Quarto → Beamer に移行。色を teal / yellow から blue / red / orange に変更
  （orange は文字色に使わず、枠・セル背景だけに限定）
- 2026-08：日本語フォントを Yu Gothic から Noto Sans JP（Medium / SemiBold）に変更（通常ウェイトが細く投影で読みにくかったため）。
  blue の文中単独強調を解禁し、文中強調を `\alert` から `\textcolor{mainred|mainblue}{...}` に統一。
  Outline の現在セクションが blue にならない不具合（`\hypersetup` の `linkcolor` が優先される）を修正
