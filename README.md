# koyama-beamer：Quarto で作る日本語 Beamer スライド

Markdown（Quarto）で書いて、Beamer の PDF スライドを出すテンプレートです。
経済学などの研究発表向けに、色の役割・表・数式・図のルールを決めてあります。

- 出力：Beamer PDF（metropolis + 上部ナビバー、4:3、lualatex）
- 日本語：Noto Sans JP（欧文は Noto Sans）
- 文献：biblatex（APA）+ biber
- 見本：[`template.pdf`](template.pdf)（どこに何を置くかを示す概念的な例）

---

## 2つの版（v1 / v2）

デザインの違う2つの版があります。どちらも同じフォント・同じ書き方（Markdown＋一部 LaTeX）で、色の名前と役割も共通です。

| | v1（`koyama-beamer`） | v2（`koyama2-beamer`） |
|---|---|---|
| 縦横比 | 4:3 | 16:9 |
| 見た目 | 上部にナビバー、淡い青のタイトル帯 | 白地に番号の四角とタイトル、右上にセクション名と ○●（セクション内の位置） |
| 色 | 青・赤・橙 | ティール・コーラル赤・橙 |
| 表紙 | タイトル・発表者・所属 | 学会名とグラデーションの帯、著者の名前と所属を横に並べる |
| 置き場所 | このフォルダの直下 | [`v2/`](v2/) |
| 見本 | [`template.pdf`](template.pdf) | [`v2/template.pdf`](v2/template.pdf) |
| ルール | [docs/SlideRules.md](docs/SlideRules.md) | [v2/docs/SlideRules.md](v2/docs/SlideRules.md)・[v2/docs/recipes.md](v2/docs/recipes.md) |

v2 を使うときは、下のコマンドのパスの最後に `/v2` を付けます（`quarto use template <koyama-beamer のパス>/v2`）。
公開（Public）後は `quarto use template Kenshi-Koyama/koyama-beamer/v2`。

---

## はじめて使う人は

**[docs/getting-started.md](docs/getting-started.md) を上から順に進めてください。**
GitHub の招待の受け方、ソフトのインストール、最初のスライドを PDF にするまでを1つずつ説明しています。

---

## 使い方の早見（2回目以降）

環境（Git・Quarto・TinyTeX・Noto Sans JP）と、このリポジトリの clone が済んでいる前提です。

```bash
# 新しいスライドを作る（研究のフォルダの中で）
mkdir -p report/slide && cd report/slide
quarto use template <koyama-beamer のパス> --no-prompt
quarto render slide.qmd

# テンプレートの更新を受け取る
cd <koyama-beamer のパス> && git pull
```

- できるもの：`slide.qmd`（本体。ここを書き換える）、`ref.bib`（文献）、`_extensions/koyama/`（テンプレート本体。書き換えない）
- 既にある `.qmd` にテンプレートだけ入れるときは、その `.qmd` のフォルダで `quarto add <koyama-beamer のパス>` を打ち、
  YAML を `format: koyama-beamer: default` にする
- 公開（Public）後は、clone せずに `quarto use template Kenshi-Koyama/koyama-beamer` でも使える

### YAML のオプション

```yaml
section-outline: false        # 各セクション冒頭の Outline を入れない（短い発表用）
bib-file: ../paper/refs.bib   # 文献ファイル（既定はスライドと同じフォルダの ref.bib）
palette:                      # この研究用に色を差し替える（書いた色だけ。docs/recipes.md の 7.）
  primary: "1F4E79"
```

縦横比・エンジンなど（`aspectratio: 43`、`pdf-engine: lualatex`、`slide-level: 2`、`keep-tex: true`、
`citeproc: false`）はテンプレートが設定するので、YAML に書かなくてよい。

---

## 文書

| ファイル | 中身 |
|---|---|
| [docs/getting-started.md](docs/getting-started.md) | はじめて使う人へ：インストールから最初のスライドまで、困ったとき |
| [docs/SlideRules.md](docs/SlideRules.md) | デザインのルール（色・レイアウト・箇条書き・表・図・引用） |
| [docs/workflow.md](docs/workflow.md) | 作る順番（6段階）、カラーパレットの決め方、文言・図表の作り方 |
| [docs/recipes.md](docs/recipes.md) | 応用（Outline なし・論文と `.bib` 共有・色の差し替え・共著者・図表の貼り方） |
| [CHANGELOG.md](CHANGELOG.md) | 変更履歴（更新を取り込む前に読む） |

---

## テンプレートの版と過去のスライド

`quarto use template` / `quarto add` は、テンプレートを**各スライドのフォルダに複製**します。
このリポジトリが更新されても、過去のスライドは作ったときの版のまま変わりません（発表済みの見た目が崩れない）。
作りかけのスライドに新しい版を入れる方法は [getting-started.md の 6.](docs/getting-started.md) を見てください。
版によって命令や色の名前が変わることがあるので、取り込む前に [CHANGELOG.md](CHANGELOG.md) を確認してください。

---

## 管理者向け：テンプレートを直すとき

1. `_extensions/koyama/` を直す（ルールが変わるなら `docs/SlideRules.md` も）。
   v2 は `v2/_extensions/koyama2/` と `v2/docs/`
2. `quarto render template.qmd`（v2 は `v2/` で `quarto render template.qmd`）で見本が崩れていないことを確認する
3. `_extensions/koyama/_extension.yml`（v2 は `v2/_extensions/koyama2/_extension.yml`）の `version` を上げ、`CHANGELOG.md` に書く
4. コミットしてタグ（例：`v1.2.0`）を付け、`git push origin main --tags`
5. 使っている人に、更新したことと CHANGELOG の要点を連絡する
