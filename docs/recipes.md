# 応用レシピ

テンプレートの既定から外れる、よくある場面の書き方。いずれも**そのデッキだけ**の変更で、
`_extensions/econ/` の中身は書き換えない（書き換えると、テンプレートを更新したときに上書きされて消える）。

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

デッキのフォルダに `deck-preamble.tex` を作り、YAML で読み込む。テンプレートのプリアンブルの**後**に入るので、
テンプレートの色（`mainblue` など）を使った定義も書ける。

```yaml
format:
  econ-beamer:
    include-in-header: deck-preamble.tex
```

```latex
% deck-preamble.tex の例：論文の図と同じ区分の色
\definecolor{sevteal}{HTML}{43B0B1}
```

ほかのデッキでも使えそうな命令ができたら、テンプレート本体に取り込む（[CHANGELOG](../CHANGELOG.md) に記録）。

## 4. 共著者が複数いる・著者欄を整形したい

YAML の `author:` に `\\`（改行）や `\textsuperscript` を入れると Quarto の著者処理が失敗する。
YAML 側は空にして、`deck-preamble.tex` で直接定義する。

```yaml
author: []
format:
  econ-beamer:
    include-in-header: deck-preamble.tex
```

```latex
% deck-preamble.tex
% Quarto は author が空でも \begin{document} の直前に \author{} を出すので、
% \AtBeginDocument で後回しにしてこちらを最後に効かせる。
\AtBeginDocument{%
\author{発表者A\textsuperscript{*}　X大学\\
共著者B　Y大学\\
{\footnotesize\textcolor{textgray}{＊：発表者}}}%
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
