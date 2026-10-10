# 変更履歴

版は `_extensions/koyama/_extension.yml` の `version`。

## 1.1.0（2026-10-11）

- 見本（`template.qmd`）を具体的な架空の研究例から、どこに何を置くかを示す概念的な内容に変更
  （タイトル「タイトル」、先行研究は「論点A」など）。文献も例とわかる書誌（実在しない）に。発表者の見解のスライドは削除

- 太字の見出し語を左端から書き、子の箇条書きを1段上げる形に変更（比較の C 案）。見出しの直下の空きを詰める `\koyamaListHead`
- `bluebox`（補足の囲み）を本体に追加。使うかはスライドごとに判断する（ふだんは使わない）。囲みは `defbox`・`bluebox`・`keytakeaway` の3種類

- ルール追加：スライドのタイトルは黒字だけ（意見スライドの見出しを `accent` にする旧ルールは廃止）
- ルール追加：文中の一部分を枠（`\ybox`）で囲わない。`\ybox` は表の中の値だけに使う
- ルール追加：矢印で始まる項目には ● を付けない（`- $\to$ …` / `- → …` で自動的に ● の位置に矢印を置く）

- 拡張機能の名前を `econ` から `koyama` に変更（`format: koyama-beamer`）
- 色を役割の名前に変更（パレットを差し替えても名前と色が食い違わないように）：
  `mainblue`→`primary`、`subblue`→`primarylight`、`midblue`→`primarymid`、`mainred`→`accent`、
  `subred`→`accentlight`、`mainorange`→`highlight`、`textblack`→`textmain`、`textgray`→`textmuted`、`bgwhite`→`background`
- 図のルールを「なるべく大きく見せる」方針と、スライドごとに選ぶ手段の一覧に変更（型は決め打ちしない）。
  2カラムの幅も決め打ちをやめた。縦横比は 4:3 のまま

- 基本方針を「1枚 = 1メッセージ」だけにし、リード文・箇条書き・`⇒` の結論は必要なときだけ使う型に変更（図表だけのスライドも可）
- `Table X:` / `Figure X:` のラベルを blue から黒の太字に変更
- 太字だけの見出し項目（下に子の箇条書きがあるもの）は自動で ● を付けない
- YAML の `palette:` で研究ごとに色を差し替えられるようにした。workflow に「パレットを決める」段階を追加
- 参考文献リストを 7pt・行送り 8.4pt にし、1枚に多く載せる（以前は biblatex と metropolis の既定で `\normalsize` になっていた）。
  続きのページのタイトル番号（i, ii …）を付けない
- recipes の誤りを修正：`deck-preamble.tex` はテンプレートのプリアンブルより前に入る

## 1.0.0（2026-10-10）

各研究に散らばっていたプリアンブルとルールを、このリポジトリに一本化した最初の版。

- Quarto の拡張機能にした（`format: koyama-beamer`）。`quarto use template` / `quarto add` で各デッキに入れる
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
  blue の文中単独強調を解禁し、文中強調を `\alert` から `\textcolor{mainred|mainblue}{...}`（当時の色名） に統一。
  Outline の現在セクションが blue にならない不具合（`\hypersetup` の `linkcolor` が優先される）を修正
