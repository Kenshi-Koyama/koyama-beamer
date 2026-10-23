---
name: slides
description: 研究発表のスライド（学会・研究会・ゼミ）を Quarto + Beamer の日本語テンプレート koyama-beamer（ver2 16:9 / ver1 4:3）で作る・直す。版の選択、研究フォルダへの導入、作る順番（大枠から試作までの6段階）、デザインのルール、PDF の確認までを案内する。
when_to_use: 「発表スライドを作りたい」「学会のスライド」「ゼミの発表資料」「この論文をスライドにしたい」「Beamer のスライド」「slide.qmd / index.qmd を直したい」など、研究発表のスライドを作る・直す・ビルドするとき。Use when the user wants to create, edit, or build a research presentation / slide deck (Quarto, Beamer, PDF), or mentions koyama-beamer.
argument-hint: "[発表の内容や会場など、分かっていること]"
---

# 研究発表のスライドを作る（koyama-beamer）

テンプレートと文書は、このプラグインのフォルダ `${CLAUDE_PLUGIN_ROOT}` にある。

| 何 | 場所 |
|---|---|
| 版の比較（どちらを使うか） | `${CLAUDE_PLUGIN_ROOT}/README.md` |
| 作る順番（6段階のゲート） | `${CLAUDE_PLUGIN_ROOT}/docs/workflow.md` |
| ver2（16:9）のテンプレート | `${CLAUDE_PLUGIN_ROOT}/ver2/`（ルール `docs/SlideRules.md`、応用 `docs/recipes.md`、見本 `template.qmd`） |
| ver1（4:3）のテンプレート | `${CLAUDE_PLUGIN_ROOT}/ver1/`（同じ構成） |
| 環境の準備・困ったとき | `${CLAUDE_PLUGIN_ROOT}/docs/getting-started.md` |

ルールの中身はこの SKILL.md に書かない。必要になった段階で上の文書を読む。

## 0. 最初にすること

1. `${CLAUDE_PLUGIN_ROOT}/docs/workflow.md` を読む。その6段階（大枠 → セクション構成 → セクションの内容 → スライド単位 → デザイン・レイアウト → 試作）の順に進め、
   前の段階に合意してから次へ進む。大枠が決まる前に、スライドの構成表や枚数を先に出さない。
2. 作業中のフォルダに `CLAUDE.md` があれば、その研究の決まり（数値を本文に直書きしない、図の作り方など）に従う。
   テンプレートのルールとぶつかるときは、研究の決まりを優先し、ぶつかったことをユーザーに伝える。

## 1. 環境を確かめる（そのパソコンで初めてのときだけ）

- `quarto --version`（1.4 以上）と `quarto check`（LaTeX が見つかること）
- 足りないものがあれば `${CLAUDE_PLUGIN_ROOT}/docs/getting-started.md` の 2.（Quarto・TinyTeX・Noto Sans JP）を案内する。
  ソフトやフォントのインストールは、ユーザーに確認してから行う

## 2. 版を選ぶ

README の「どちらを使うか」を要約して、ユーザーに選んでもらう（迷っていれば ver2 を勧める）。

- **ver2（16:9）**：白地で図や主張を大きく見せる。表紙に学会名・共著者と所属。最近の学会・オンライン発表向け
- **ver1（4:3）**：上部のナビバーで常に全体の位置を見せる。4:3 の会場や、ver1 で作った過去の発表の続きに

以下、選んだ版のフォルダを `<版>`（`${CLAUDE_PLUGIN_ROOT}/ver2` か `${CLAUDE_PLUGIN_ROOT}/ver1`）と書く。

## 3. 置き場所を決めて、テンプレートを入れる

どこに置くかは、研究フォルダの作りで決まる。

**A. `slides/_quarto.yml` がある**（`slides/` が独立した Quarto プロジェクトで、発表を `slides/YYMMDD_venue/index.qmd` に置く研究フォルダ）

`<版>/docs/recipes.md` の「研究フォルダの `slides/` に入れる」（ver2 は 11.、ver1 は 9.）の手順どおりに入れる。要点：

```bash
cd <研究フォルダ>/slides
mkdir <YYMMDD_venue> && cd <YYMMDD_venue>     # 発表日と会場の名前はユーザーに聞く。フォルダは空であること
quarto use template <版> --no-prompt
mv <YYMMDD_venue>.qmd index.qmd
rm ref.bib
```

- `index.qmd` の YAML に `bib-file: ../references.bib` を書く（共有の文献）。ver2 の見本には `date-format: "YYYY.M.D"` が最初から入っている
- 研究フォルダの `.gitignore` に `slides/**/*.tex` が無ければ、足してよいか聞いてから足す
- `code/`・`output/`・`data` のリンクは、その研究フォルダの決まり（`CLAUDE.md` や既存の発表フォルダ）どおりに作る

**B. それ以外**

ユーザーに置き場所を聞く（目安：研究フォルダの中の `report/slide/`）。空のフォルダで：

```bash
quarto use template <版> --no-prompt
```

`<フォルダ名>.qmd`・`ref.bib`・`_extensions/` ができる。

**どちらの場合も**

- 発表のフォルダの `_extensions/` の中は書き換えない（テンプレートの更新で上書きされる）
- 発表済みのスライドのテンプレートは更新しない（作ったときの版のまま残すことで、あとで同じ見た目でビルドできる）

## 4. 中身を決める（workflow の段階 1〜4）

- 材料（論文の原稿、`manuscript/`、`notes/`、図表の出力など）を読み、まず大枠（誰に向けて、何を押し出し、発表のゴールは何か）について考えを聞く
- 合意した内容を、スライド用に体言止め・断片・矢印（→）に切る。1枚に言いたいことは1つ

## 5. 書く（workflow の段階 5）

書き始める前に、`<版>/docs/SlideRules.md` を読む。見本の `<版>/template.qmd` が、各部品の書き方の実例になっている。

- **カラーパレット**：最初に決める（workflow の 2.）。変えるときは YAML の `palette:`
- **本文の最初は `#` の行**（セクション）。`##` がスライド1枚
- **よく間違えるところ**
  - Markdown の中で `{\centering …}` のように波括弧で囲むと、波括弧が文字として出る。中央ぞろえは `\leadline{…}`（ver2）か `\begin{center}…\end{center}`
  - スライドのタイトルは黒字だけ。文中の強調は `\textcolor{accent}{…}` / `\textcolor{primary}{…}`（`\alert` は使わない）
  - まとめのカテゴリ（Research Question、Data、Findings など）は `- **見出し**` の下に子の箇条書きを置く（● が付かない）
  - 付録は References の下に `\appendix` を書き、そのあとを `#` で始める（ver2 は A1, A2 … になる）
  - ver2 の `venue:` に「@」を書かない（表紙で自動で付く）
- **R で図を描く**：最初の setup チャンクで図の形式と実寸を指定する（`<版>/docs/recipes.md` の「R のチャンクで図を描く」。ver2 は 12.、ver1 は 10.）。
  YAML の `knitr:` には書かない（R を使わない発表でも R が必要になる）
- **図の大きさ**：SlideRules の 7. の実寸（ver2 は幅 5.4 インチ・高さ 1.6〜1.9 インチまで、ver1 は幅 4.25 インチ・高さ 2.15〜2.4 インチまで）

## 6. ビルドして確かめる（workflow の段階 6）

```bash
quarto render <発表のファイル>.qmd
```

- 研究フォルダの `slides/` プロジェクトの発表は、研究フォルダのいつものやり方でビルドする（R のパッケージの環境など）
- 初回は LaTeX の部品の自動ダウンロードで数分かかる。ver2 は右上の ○● と目次のために、lualatex が自動で複数回走る
- できた PDF を **ページごとに画像で見て**確かめる：下へのはみ出し、文字の重なり、図の大きさ、強調の多すぎ、
  ver2 の表紙の最下部（セクション名と ○）。SlideRules の最後のチェックリストで見直す
- 直したら再ビルドして、もう一度見る

## 7. つまずいたとき

| 症状 | 対処 |
|---|---|
| `quarto use template` で `.qmd` ができない | パスの最後が `ver1` か `ver2` になっているか。リポジトリの直下では何も配られない |
| `Could not convert a SVG to a PDF` | `_quarto.yml` が図を svg で出している。setup チャンクで `dev = "cairo_pdf"`（5. の R の図） |
| 表紙の日付が「October 23, 2026」の形 | 上位の `_quarto.yml` の `date-format`。発表の YAML に `date-format: "YYYY.M.D"` |
| `Font "Noto Sans JP" not found` など | フォントが入っていない（getting-started の 2.4） |
| 先頭に空白のスライド | 本文の最初が `#` の行になっていない |
| 文献が `[key]` のまま | `.bib` のキーの綴り、または `bib-file:` のパス |
| ver2 の ○● や目次が空 | 1回目のコンパイル。`quarto render` を最後まで走らせれば、自動で再コンパイルされて埋まる |

ほかは `${CLAUDE_PLUGIN_ROOT}/docs/getting-started.md` の「困ったとき」と、各版の recipes を見る。
