# koyama-beamer：Quarto で作る日本語 Beamer スライド

Markdown（Quarto）で書いて、Beamer の PDF スライドを出すテンプレート。
経済学などの研究発表向けに、色の役割・表・数式・図のルールを決めてある。

- 出力：Beamer PDF（metropolis + 上部ナビバー、4:3、lualatex）
- 日本語：Noto Sans JP（欧文は Noto Sans）
- 文献：biblatex（APA）+ biber
- 見本：[`template.pdf`](template.pdf)（どこに何を置くかを示す概念的な例）

## 文書

| ファイル | 中身 |
|---|---|
| [docs/SlideRules.md](docs/SlideRules.md) | デザインのルール（色・レイアウト・箇条書き・表・図・引用） |
| [docs/workflow.md](docs/workflow.md) | 作る順番（6段階のゲート形式）と文言・図表の作り方 |
| [docs/recipes.md](docs/recipes.md) | 応用（Outline なし・論文と `.bib` 共有・独自の色・共著者・図表の貼り方） |
| [docs/setup.md](docs/setup.md) | 環境構築（Quarto・TinyTeX・フォント） |
| [CHANGELOG.md](CHANGELOG.md) | 変更履歴 |

## 使い方

初めて使うときは、先に [docs/setup.md](docs/setup.md) の環境（Quarto・TinyTeX・Noto Sans JP）を用意する。

### 0. このリポジトリを手元に置く（最初の1回だけ）

このリポジトリは Private なので、招待された人が手元に clone して、そのフォルダを指定して使う。

```bash
git clone git@github.com:Kenshi-Koyama/koyama-beamer.git   # 好きな場所に（HTTPS なら https://github.com/Kenshi-Koyama/koyama-beamer.git）
```

テンプレートが更新されたら、clone したフォルダで `git pull` する。

### 新しいスライドを作る

研究ごとに `report/slide/` で作る（研究のフォルダの中に置き、図表は分析の出力から相対パスで読む）。

```bash
cd <研究のフォルダ>/report
quarto use template <cloneしたフォルダのパス>
# 公開後は clone せずに: quarto use template Kenshi-Koyama/koyama-beamer
```

フォルダ名を聞かれるので `slide` などと答える。中に次の3つができる：

```
report/slide/
├── slide.qmd        ← 見本（template.qmd）がフォルダ名に改名されたもの。ここを書き換える
├── ref.bib          ← 文献
└── _extensions/koyama/ ← テンプレート本体（書き換えない）
```

あとは `slide.qmd` の YAML（`title` など）と本文を書き換えて、

```bash
quarto render slide.qmd
```

### 既にある `.qmd` にテンプレートだけ入れる

```bash
quarto add <cloneしたフォルダのパス>
# 公開後は: quarto add Kenshi-Koyama/koyama-beamer
```

YAML の `format:` を次のようにする：

```yaml
format:
  koyama-beamer: default
```

### YAML のオプション

```yaml
section-outline: false        # 各セクション冒頭の Outline を入れない（短い発表用）
bib-file: ../paper/refs.bib   # 文献ファイル（既定はスライドと同じフォルダの ref.bib）
palette:                      # この研究用に色を差し替える（書いた色だけ。docs/recipes.md の 7.）
  primary: "1F4E79"
```

縦横比・エンジンなど（`aspectratio: 43`、`pdf-engine: lualatex`、`slide-level: 2`、`keep-tex: true`、
`citeproc: false`）はテンプレートが設定するので、YAML に書かなくてよい。

### 書き方の基本

- `#` = セクション（上部のナビバーに出る）、`##` = スライド1枚
- **本文の先頭は必ず `#` 見出しで始める**（前に地の文やコメントがあると空のスライドが出る）
- 細かい装飾は生 LaTeX で書く（例：`\textcolor{accent}{強調}`、`\cellcolor{highlight!25}`（表のセル）、`\srcite{key}`）。
  部品の一覧は [SlideRules.md の 11.](docs/SlideRules.md)

## テンプレートの更新と過去のスライド

`quarto use template` / `quarto add` は、テンプレートを**各デッキのフォルダに複製**する。
このリポジトリを更新しても、過去のデッキは作ったときの版のまま変わらない（発表済みの見た目が崩れない）。
新しい版を既存のデッキに入れたいときだけ、clone したフォルダで `git pull` してから、
そのデッキのフォルダで `quarto add <cloneしたフォルダのパス>` をやり直す。

テンプレートを直すときは：

1. `_extensions/koyama/` を直す（ルールが変わるなら `docs/SlideRules.md` も）
2. `quarto render template.qmd` で見本が崩れていないことを確認
3. `_extensions/koyama/_extension.yml` の `version` を上げ、`CHANGELOG.md` に書く
