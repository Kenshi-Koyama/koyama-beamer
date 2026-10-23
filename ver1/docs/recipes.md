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
