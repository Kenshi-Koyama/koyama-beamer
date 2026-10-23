# 応用レシピ（v2）

v2（`koyama2-beamer`）で、テンプレートの既定から外れるよくある場面の書き方。v1 のものは [../../ver1/docs/recipes.md](../../ver1/docs/recipes.md)。
いずれも**そのデッキだけ**の変更で、`_extensions/koyama2/` の中身は書き換えない
（書き換えると、テンプレートを更新したときに上書きされて消える）。

---

## 1. 短い発表で目次を入れない

```yaml
section-outline: false
```

2つ目以降の各セクション冒頭の目次スライドが入らなくなる。今どこにいるかは右上のセクション名と ○● だけで示す
（全体の構成は、表紙の最下部の帯にそのまま出る）。
目安は 15〜20 分以下の発表。

## 2. 論文と同じ `.bib` を使う

```yaml
bib-file: ../paper/refs.bib
```

パスはスライドの `.qmd` があるフォルダから見た相対パス。指定しなければ同じフォルダの `ref.bib`。

## 3. そのデッキだけの色・命令を足す

デッキのフォルダに `deck-preamble.tex` を作り、YAML で読み込む。

```yaml
format:
  koyama2-beamer:
    include-in-header: deck-preamble.tex
```

`deck-preamble.tex` はテンプレートのプリアンブルより**前**に入る。テンプレートの色（`primary` など）や命令を使う定義、
テンプレートの設定の上書きは `\AtBeginDocument{...}` の中に書く。

```latex
\AtBeginDocument{%
  \colorlet{sevlight}{primary!20!white}%
}
```

## 4. 著者を書く（表紙）

名前・所属・発表者の印は YAML に書けば、表紙に横に並ぶ（発表者に `*`）。

```yaml
author:
  - name: 小山 拳志
    affiliation: The University of Osaka
    presenter: true
  - name: 共著者名
    affiliation: 所属
```

- 所属が複数あるときは `affiliations:` に並べる（`, ` でつないで表示される）。
- 著者が1人で `affiliation` が無いときは、`institute:` が所属として出る。
- 4人を超えると1人あたりの幅が狭くなるので、所属は短く書く。

YAML で書けない形（上付きの記号で所属を対応させるなど）にしたいときは、`deck-preamble.tex` で直接定義する。

```latex
% deck-preamble.tex：\koyamaAuthor{名前}{所属}{発表者なら 1}
\AtBeginDocument{%
  \def\koyamaAuthorCount{2}%
  \def\koyamaAuthors{\koyamaAuthor{発表者A\textsuperscript{1}}{X大学}{1}\koyamaAuthor{共著者B\textsuperscript{2}}{Y大学}{0}}%
}
```

## 5. 研究フォルダの図表を貼る

v1 と同じ。図表は分析コードの出力フォルダから相対パスで読む（スライド用にコピーしない）。

```latex
\begin{center}\includegraphics[width=\linewidth]{../../output/figures/slides/f1_trend.png}\end{center}
\begin{center}\small\input{../../output/tables/slides/t1_desc.tex}\end{center}
```

16:9 の図の実寸（幅 5.4 インチ・高さ 1.6〜1.9 インチまで）は [SlideRules.md](SlideRules.md) の 7.。

## 6. 出力ファイル名を変える

```yaml
output-file: Name_2026-10_seminar.pdf
```

## 7. この研究用にカラーパレットを変える

YAML の `palette:` に、差し替えたい色だけを6桁の16進で書く（`#` はあってもなくてもよい）。

```yaml
palette:
  primary: "1F4E79"     # 構造・強調（四角・●・目次の線など）
  accent: "C00000"      # 強調・対比の一方・赤い枠
  highlight: "F2B134"   # 表の注目・3つ目の区分
```

使える色名：`textmain` `textmuted` `textlight` `textfaint` `primary` `primarylight` `accent` `accentlight` `highlight`。
淡い色は書かなければ自動で作られる：`primarylight`（`defbox` の地）は `primary` の 20%、
`accentlight` は `accent` の 28%、四角の影（`primarymid`）は `primary` の 45%、目次の淡い四角は 30%・13%。
色名を間違えたときは、レンダリング時に警告が出てその指定は無視される。

## 8. 参考文献の文字の大きさを変える

既定は 7pt（行送り 8.4pt）。`deck-preamble.tex` に書く：

```latex
\newcommand{\koyamaBibSize}{\fontsize{6}{7.2}\selectfont}
```

## 9. 付録（Appendix）

References の下に `\appendix` を書き、そのあとを `#` のセクションで始める。

```markdown
## References {.allowframebreaks}

\printbibliography[heading=none]

\appendix

# 記述統計

## 記述統計量

…

# 頑健性の確認

## 別の対照群での推定
```

- `\appendix` のあとのセクションは、四角の番号が `A1, A2 …` になり、目次には載らない。
- 付録に入るのは `\appendix` の**次のセクションの始まり**から（References のページ番号が 0 にならないように）。
  `\appendix` のあとを `#` で始めないと、付録として扱われない。
- 本編から付録へ飛ぶボタン：本編側に `\hyperlink{appendixstats}{\beamerbutton{記述統計へ $\rightarrow$}}`、
  付録側のスライドに `\hypertarget{appendixstats}{}`。

## 10. 表紙の学会名・会場・目次の短いタイトル

```yaml
title: "State-Contingent Pricing for Congestible Public Services: Evidence from Ambulance Policy in Japan"
shorttitle: "State-Contingent Pricing for Congestible Public Services"   # 目次スライドの左上
event: "医療経済学会 第21回研究大会"   # 表紙の右上（ティール）
venue: "東京大学"                     # 日付のあとに「@東京大学」
date: 2026-09-05                       # 「2026.9.5」と出る（date-format は YYYY.M.D）
```

`event:` を書かなければ、表紙の右上のグラデーションの帯も出ない（日付@会場だけ）。
`subtitle:` を書くと、タイトルの下に少し小さく出る。
