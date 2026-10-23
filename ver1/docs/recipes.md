# 応用レシピ（v1）

v1（`koyama-beamer`、4:3）の応用。v2 のものは [../../ver2/docs/recipes.md](../../ver2/docs/recipes.md)。

テンプレートの既定から外れる、よくある場面の書き方。いずれも**そのデッキだけ**の変更で、
`_extensions/koyama/` の中身は書き換えない（書き換えると、テンプレートを更新したときに上書きされて消える）。

---

## 1. 短い発表で Outline を入れない

```yaml
section-outline: false
```

各セクション冒頭の Outline スライドが入らなくなる（metropolis 既定のセクション区切りページも出ない）。
現在位置は上部のナビバーだけで示す。目安は 15〜20 分以下の発表。

## 2. 論文と同じ `.bib` を使う

```yaml
bib-file: ../paper/refs.bib
```

パスはスライドの `.qmd` があるフォルダから見た相対パス。指定しなければ同じフォルダの `ref.bib`。

## 3. そのデッキだけの色・命令を足す

デッキのフォルダに `deck-preamble.tex` を作り、YAML で読み込む。

```yaml
format:
  koyama-beamer:
    include-in-header: deck-preamble.tex
```

```latex
% deck-preamble.tex の例：論文の図と同じ区分の色
\definecolor{sevteal}{HTML}{43B0B1}
```

注意：`deck-preamble.tex` はテンプレートのプリアンブルより**前**に入る。
そのため、テンプレートの色（`primary` など）や命令を使う定義・テンプレートの設定を上書きしたいときは、
`\AtBeginDocument{...}` の中に書く（本文の直前に実行されるので、テンプレートより後に効く）。

```latex
% 例：テンプレートの設定より後に効かせたいもの
\AtBeginDocument{%
  \colorlet{sevlight}{primary!20!white}%
}
```

ほかのデッキでも使えそうな命令ができたら、テンプレート本体に取り込む（[CHANGELOG](../../CHANGELOG.md) に記録）。

## 4. 共著者が複数いる・著者欄を整形したい

YAML の `author:` に `\\`（改行）や `\textsuperscript` を入れると Quarto の著者処理が失敗する。
YAML 側は空にして、`deck-preamble.tex` で直接定義する。

```yaml
author: []
format:
  koyama-beamer:
    include-in-header: deck-preamble.tex
```

```latex
% deck-preamble.tex
% Quarto は author が空でも \begin{document} の直前に \author{} を出すので、
% \AtBeginDocument で後回しにしてこちらを最後に効かせる。
\AtBeginDocument{%
\author{発表者A\textsuperscript{*}　X大学\\
共著者B　Y大学\\
{\footnotesize\textcolor{textmuted}{＊：発表者}}}%
}
```

## 5. 研究フォルダの図表を貼る

スライドは各研究の `report/slide/` に置き、図表は分析コードの出力フォルダから相対パスで読む
（スライド用にコピーしない＝作り直したときに自動で最新になる）。

```latex
\begin{center}\includegraphics[width=\linewidth]{../../output/figures/slides/f1_trend.png}\end{center}
\begin{center}\small\input{../../output/tables/slides/t1_desc.tex}\end{center}
```

## 6. 出力ファイル名を変える

```yaml
output-file: Name_2026-10_seminar.pdf
```

## 7. この研究用にカラーパレットを変える

YAML の `palette:` に、差し替えたい色だけを6桁の16進で書く（`#` はあってもなくてもよい）。
書かなかった色は既定のまま。どの色を変えるかは [workflow.md](../../docs/workflow.md) の 2. で決める。

```yaml
palette:
  primary: "1F4E79"     # 構造・強調（帯・●・ナビなど）
  accent: "C00000"      # 強調・対比の一方
  highlight: "F2B134"   # 表・数値の注目（枠・セル背景）
```

使える色名：`textmain` `textmuted` `primary` `primarylight` `accent` `accentlight` `highlight`。
淡い色は書かなければ自動で作られる：`primarylight`（タイトル帯・定義ボックスの地）は `primary` の 12%、
`accentlight`（alert ブロックの地）は `accent` の 35%、`primarymid`（ナビバー・ブロック本文の地）は `primary` の 35%。
自動の淡い色が合わないときだけ、`primarylight: "E6EEF6"` のように書いて指定する。
色名を間違えたときは、レンダリング時に警告が出てその指定は無視される。

## 8. 参考文献の文字の大きさを変える

既定は 7pt（行送り 8.4pt）。変えたいときは `deck-preamble.tex` に書く：

```latex
\newcommand{\koyamaBibSize}{\fontsize{6}{7.2}\selectfont}
```

## 9. 研究フォルダの `slides/` に入れる（発表ごとのフォルダ・共有の文献）

研究フォルダが `slides/` を独立した Quarto プロジェクト（`slides/_quarto.yml`）にしていて、
発表を `slides/YYMMDD_venue/index.qmd`（中に `code/`・`output/`・`data`）の形で置く場合の入れ方。

```bash
cd <研究フォルダ>/slides
mkdir 261023_jhea && cd 261023_jhea                       # 空のフォルダを作って入る
quarto use template <koyama-beamer のパス>/ver1 --no-prompt
mv 261023_jhea.qmd index.qmd                              # 研究フォルダの決まりの名前に
rm ref.bib                                                # 文献は共有の slides/references.bib を使う
```

`index.qmd` の YAML：

```yaml
bib-file: ../references.bib
date-format: "YYYY-MM-DD"  # slides/_quarto.yml の date-format（long など）を使わず、見本と同じ形にしたいとき
```

- 拡張機能は発表のフォルダ（`slides/261023_jhea/_extensions/koyama/`）に入る。
  発表を「凍結したスナップショット」として扱う方針に合う（テンプレートを更新しても、過去の発表は作ったときの版のまま）。
  全部の発表で共有したいときは、`slides/` で `quarto add <koyama-beamer のパス>/ver1` を打てば `slides/_extensions/koyama/` に入り、それでも動く
- `slides/_quarto.yml` に `author:` があっても、発表の YAML に `author:` を書けば上書きされる
- テンプレートは `keep-tex: true` なので `index.tex` が残る。研究フォルダの `.gitignore` に `slides/**/*.tex` を足す
  （PDF と `*_files/` は、ふつうその研究フォルダの `.gitignore` で無視されている）
- 同じ `slides/` の中の Touying（Typst）などの発表とは形式名が違うので、共存できる
- `code/`・`output/`・`data` のリンクは、研究フォルダの決まりどおりに作る
- R で図を描くときは、次の 10. を必ず行う（`slides/_quarto.yml` が図を `svg` で出す設定だと、ビルドが止まる）

## 10. R のチャンクで図を描く

最初の setup チャンクで、図の出し方をこのテンプレート（PDF・実寸）に合わせる。

```r
knitr::opts_chunk$set(
  dev = "cairo_pdf",  # PDF に貼れる形式。svg のままだと rsvg-convert が無いとビルドが止まる
  fig.width = 4.25,     # 本文の幅いっぱい（インチ）
  fig.height = 2.15,    # タイトル＋リード1行＋図＋キャプションと注2行で収まる高さ（リード文なしなら 2.4）
  out.width = "100%"  # 縮小せず等倍で貼る（文字の大きさが狂わない）
)
ggplot2::theme_set(ggplot2::theme_classic(base_family = "Noto Sans JP", base_size = 9))
```

- YAML の `knitr: opts_chunk:` に書く方法もあるが、そうすると R のチャンクが無い発表でも R が呼ばれる。setup チャンクに書く
- 研究フォルダの `slides/_quarto.yml` に `knitr: opts_chunk:`（`dev: svg`、`fig.width: 8` など）があっても、setup チャンクの設定が優先される
  （YAML の `fig-format: pdf` では勝てない）
- 図の文字はスライドと同じ Noto Sans JP、9pt（軸 8.5pt・凡例 9pt の目安。[SlideRules.md](SlideRules.md) の 7.）。日本語のラベルも出る
- 図ごとに大きさを変えるときは、チャンクに `#| fig-width: 3` `#| fig-height: 1.6` のように書く
  （2カラムの左に置く図は、幅をカラムの幅に合わせる。例：55% のカラムなら `4.25 * 0.55`）
- R で作る表は `tinytable` の `tt()`（`modelsummary(..., output = "tinytable")` も）でそのまま貼れる（罫線は横だけになる）。
  強調のセル（`\cellcolor{highlight!25}`）など細かい装飾が要る表は、Markdown か LaTeX で書く
