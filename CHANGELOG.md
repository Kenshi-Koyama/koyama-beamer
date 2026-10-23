# 変更履歴

版は、v1 が `ver1/_extensions/koyama/_extension.yml`、v2 が `ver2/_extensions/koyama2/_extension.yml` の `version`。
v1 と v2 は別の拡張機能（`koyama-beamer` / `koyama2-beamer`）なので、版の番号もそれぞれで進む。

## 研究フォルダとの接続（2026-10-23）

テンプレートの拡張機能は変わらない（v1 1.1.0・v2 2.0.0 のまま）。見本と文書だけ。

- 研究フォルダの `slides/` プロジェクト（`slides/_quarto.yml`、発表は `slides/YYMMDD_venue/index.qmd`）に入れる手順を追加
  （v2 の recipes の 11.、v1 の recipes の 9.）。`index.qmd` への名前の変更、共有の `../references.bib`、`.gitignore` の追加
- R のチャンクで図を描くときの設定を追加（v2 の recipes の 12.、v1 の recipes の 10.、各版の SlideRules の 7.）。
  setup チャンクで `knitr::opts_chunk$set(dev = "cairo_pdf", fig.width = …, fig.height = …, out.width = "100%")`。
  研究フォルダの `_quarto.yml` が図を `svg` で出す設定だと、PDF に貼れずビルドが止まるため
- v2 の見本の YAML に `date-format: "YYYY.M.D"` を書いた（研究フォルダの `_quarto.yml` の `date-format: long` などより優先させるため）。
  R の設定の書き方もコメントで添えた

## リポジトリの構成の変更（2026-10-23）

v1 と v2 を、リポジトリの直下のそれぞれのフォルダ（`ver1/`・`ver2/`）に分けた。テンプレートの中身（v1 1.1.0）は変わらない。

- **v1 を使うときのパスが変わった**：`quarto use template <koyama-beamer のパス>` → `<koyama-beamer のパス>/ver1`。
  作りかけの v1 のスライドに更新を入れるときも `quarto add <koyama-beamer のパス>/ver1`。
  直下のパスのままだと、何も配られない（`slide.qmd` ができない）
- 見本の PDF を `template_ver1.pdf`・`template_ver2.pdf` にした。`template.qmd` は名前を変えない
  （`quarto use template` が `slide.qmd` などに自動で名前を変えるのは `template.qmd` だけのため）。
  見本を作り直すときは `quarto render template.qmd -o template_ver2.pdf`
- 共通の文書（getting-started・workflow）はリポジトリ直下の `docs/` に、版ごとの文書（SlideRules・recipes）は各版の `docs/` に置いた
- README を「どちらを使うか」を選ぶ入口にし、両方の版の表紙と本文の画像（`docs/images/`）と特徴の比較を載せた

## v2 2.0.0（2026-10-23）

v1 とは別に、デザインを変えた v2 を `ver2/` に追加（v1 はそのまま）。`format: koyama2-beamer`、
`quarto use template <koyama-beamer のパス>/ver2` で使う。ルールは [ver2/docs/SlideRules.md](ver2/docs/SlideRules.md)。

- 縦横比を 16:9 に。図の実寸の目安を測り直した（幅 5.4 インチ、高さ 1.6〜1.9 インチまで）
- 帯とナビバーをやめ、白地に。左上にセクション番号の四角（影つき）と黒字のタイトル、
  右上にグレーのセクション名・ページ番号と、セクションの中での位置を示す ○●
- 目次を作り直した（「目次」とティールの縦線、番号の四角、今のセクション以外は淡く）。
  目次は2つ目以降のセクションの冒頭にだけ入れる（最初のセクションの前には入れない）
- 表紙を作り直した。YAML に `event:`（学会名）・`venue:`（会場）・`shorttitle:`（目次の左上）と、
  `author:` の `affiliation:`・`presenter: true` を追加。日付は `2026.9.5` の形。
  最下部に、セクションごとの細い淡いティールの線と、本編のセクション名とスライドの数だけの ○（v1 のナビバーの形）を置き、
  全体の構成と枚数の目安を見せる。欄の幅は名前の長さに合わせて変わる（長い名前でも重ならない）
- 色：`primary` をティール、`accent` をコーラル赤、`highlight` を橙に。`textlight`・`textfaint` を追加。
  `highlight` は3つ目の区分として短い語の文字色に使ってよい
- 箇条書き：1段目はティールの小さい ●、2・3段目はティールの短い横線
- 部品を追加：`\hatch`（語句の下の斜線）、`tagbox`（Research Question / Research Gap などのラベル付きの枠）、
  `\flowdown`（▼）、`\cardbox`（値のカード）、`\leadline`（中央ぞろえの1行）。
  `keytakeaway` は赤い枠・太字・中央ぞろえに、`defbox` は淡いティールの地に
- `::: defbox … :::` で、変数定義ボックスの中を Markdown で書けるようにした（`- **見出し**` は ● なしの見出しに）
- References のスライドは、四角に番号を書かず、右上のセクション名と ○● も出さない（自動）
- 付録：`\appendix` のあとのセクションは四角が `A1, A2 …`、右上は付録のセクションの中での ○●、目次には載らない
- フォントは v1 と同じ（欧文の本文だけ Regular → Medium にして、和文の Medium とそろえた）。
  タイトル・表紙・目次・右上の表示・見出し・囲みの中身は太字

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
