# はじめて使う人へ：インストールから最初のスライドまで

このテンプレートを自分のパソコンで使えるようにして、最初のスライドを PDF にするまでの手順です。
上から順に進めてください。Git や LaTeX を使ったことがなくても進められるように書いています。

> 動作を確認しているのは **Windows** です（Quarto 1.9.37 + TinyTeX）。
> macOS の手順は同じ考え方で書いていますが、まだ実機で確認していません。うまくいかなかったら教えてください。

---

## 全体の流れ

| 手順 | やること | 回数 |
|---|---|---|
| 1 | GitHub の招待を受ける | 最初の1回 |
| 2 | ソフトを入れる（Git・Quarto・TinyTeX・フォント） | 最初の1回 |
| 3 | テンプレートを手元にコピーする（clone） | 最初の1回 |
| 4 | 見本をビルドして、正しく動くか確かめる | 最初の1回 |
| 5 | 自分のスライドを作る | 発表ごと |
| 6 | テンプレートの更新を取り込む | 更新があったとき |

---

## コマンドの打ち方（最初に読む）

この手順では、いくつかのコマンドを打ちます。コマンドを打つ画面を「ターミナル」と呼びます。

- **Windows**：スタートメニューで「**Git Bash**」を開く（手順 2.1 で Git を入れると使えるようになる）。
  PowerShell でも同じコマンドが使えます。
- **macOS**：「アプリケーション → ユーティリティ → **ターミナル**」を開く。

このページの灰色の枠の中が、打つコマンドです。1行ずつコピーして貼り付け、Enter を押します。
`#` から後ろは説明なので、打たなくてかまいません。`<名前>` のような `< >` の部分は、自分の環境に合わせて置き換えます。

> ソフトを入れたあとは、**ターミナルを一度閉じて開き直して**ください。開き直さないと、入れたソフトが見つからないことがあります。

---

## 1. GitHub の招待を受ける

このテンプレートは今は限られた人にだけ公開しています（Private）。使うには招待が必要です。

1. GitHub のアカウントを作る（持っていなければ <https://github.com/signup>）
2. 作ったアカウントのユーザー名を、テンプレートの管理者（小山）に伝える
3. 招待のメールが届いたら、メールのボタンから承認する。
   メールが見つからなければ、ログインした状態で
   <https://github.com/Kenshi-Koyama/koyama-beamer/invitations> を開いて承認する
4. <https://github.com/Kenshi-Koyama/koyama-beamer> が開ければ OK

---

## 2. ソフトを入れる

### 2.1 Git（テンプレートを手元にコピーし、更新を受け取るため）

- **Windows**：<https://git-scm.com/download/win> からインストーラーをダウンロードして実行。
  途中の選択肢はすべて初期設定のまま「Next」で進めてよい
  （GitHub へのログインを助ける Git Credential Manager も一緒に入ります）。
- **macOS**：ターミナルで `git --version` と打つ。入っていなければインストールを促す画面が出るので、それに従う。

確認（バージョン番号が出れば OK）：

```bash
git --version
```

### 2.2 Quarto（Markdown からスライドを作るソフト）

<https://quarto.org/docs/get-started/> から、自分の OS 用のインストーラーをダウンロードして実行します。

確認（`1.4` 以上なら OK。動作確認しているのは `1.9.37`）：

```bash
quarto --version
```

### 2.3 TinyTeX（PDF を作るための LaTeX）

```bash
quarto install tinytex
```

ダウンロードに数分かかります。すでに TeX Live（MacTeX を含む）を使っている人は入れなくてもかまいません。
それ以外の LaTeX（W32TeX など）しか入っていない場合は、TinyTeX を入れてください
（足りない部品の自動インストールが、TinyTeX と TeX Live でしか働かないため）。

確認：

```bash
quarto check
```

出力の中に、次の2行があれば OK です。

```
[>] Checking LaTeX....................OK
      Using: TinyTex
```

### 2.4 フォント（Noto Sans JP）

スライドの日本語は **Noto Sans JP** で表示します。パソコンに入っていないと PDF が作れません。

1. <https://fonts.google.com/noto/specimen/Noto+Sans+JP> を開き、「Get font」→「Download all」で zip をダウンロード
2. zip を展開し、中の **`static` フォルダ**を開く（`NotoSansJP-Medium.ttf`、`NotoSansJP-SemiBold.ttf` などが入っている）
3. `static` フォルダの中のファイルを**すべて**選んでインストールする
   - **Windows**：選んだファイルを右クリック →「インストール」
   - **macOS**：ファイルをダブルクリック →「インストール」（Font Book が開く）

> `static` フォルダの外にある1つのファイル（名前に `VariableFont` を含むもの）だけでは足りません。
> スライドでは Medium（本文）と SemiBold（太字）の太さを使うため、太さごとのファイルが必要です。

---

## 3. テンプレートを手元にコピーする（clone）

テンプレートを置く場所に移動してから、コピーします。
**場所のパスに空白や日本語が入らない**ところが無難です（例：ホームフォルダ）。

```bash
cd ~                                                        # ホームフォルダに移動
git clone https://github.com/Kenshi-Koyama/koyama-beamer.git
```

- 初めてのときは、ブラウザで GitHub のログイン画面が開きます。ログインすれば続きが進みます。
- 終わると、ホームフォルダの中に `koyama-beamer` というフォルダができます。
  このフォルダの場所（パス）を、この先何度も使います。
  - Windows の例：`C:/Users/<名前>/koyama-beamer`
  - macOS の例：`/Users/<名前>/koyama-beamer`

SSH の鍵を GitHub に登録してある人は、`git clone git@github.com:Kenshi-Koyama/koyama-beamer.git` でもかまいません。

---

## 4. 見本をビルドして、正しく動くか確かめる

```bash
cd ~/koyama-beamer
quarto render template.qmd
```

`template.pdf` ができ、開くと19ページの見本スライドになっていれば準備完了です。

- **初めてのビルドは時間がかかります**（数分）。足りない LaTeX の部品を自動でダウンロードするためです。2回目からは速くなります。
- うまくいかないときは、下の「[困ったとき](#困ったとき)」を見てください。

---

## 5. 自分のスライドを作る

### 5.1 スライドのフォルダを作る

研究のフォルダの中に `report/slide` という空のフォルダを作り、その中でテンプレートを展開します
（発表ごとに分けたいときは `slide` の代わりに `slide_2026-11_seminar` など）。

```bash
cd <研究のフォルダ>
mkdir -p report/slide
cd report/slide
quarto use template <koyama-beamer のパス> --no-prompt
# 例（Windows）: quarto use template C:/Users/<名前>/koyama-beamer --no-prompt
```

> **v2（16:9 のデザイン）を使うとき**は、パスの最後に `/v2` を付けます
> （`quarto use template C:/Users/<名前>/koyama-beamer/v2 --no-prompt`）。
> できるテンプレート本体は `_extensions/koyama2/`、ルールは [v2/docs/SlideRules.md](../v2/docs/SlideRules.md)。
> v1 と v2 の違いは [README](../README.md) の「2つの版」。

中に次の3つができます（`slide.qmd` の名前は、フォルダの名前に合わせて自動で付きます）。

```
report/slide/
├── slide.qmd           ← スライドの本体。ここを書き換える
├── ref.bib             ← 参考文献のリスト
└── _extensions/koyama/ ← テンプレート本体（書き換えない）
```

### 5.2 書き換えてビルドする

1. `slide.qmd` をエディタで開く（VS Code・RStudio・メモ帳など何でもよい）
2. 先頭の `---` で囲まれた部分（YAML）の `title`・`subtitle`・`author`・`institute` を書き換える
3. 本文を書き換える。いま入っているのは「どこに何を置くか」の見本なので、使わないスライドは消してよい
4. ビルドする

```bash
cd <研究のフォルダ>/report/slide
quarto render slide.qmd
```

`slide.pdf` ができます。RStudio を使う人は、`slide.qmd` を開いて「Render」ボタンを押してもビルドできます。

### 5.3 書き方の基本

- `#` で始まる行 = セクション（上部のナビバーに出る）、`##` で始まる行 = スライド1枚
- **本文の最初は必ず `#` の行から始める**（前に文章があると、空白のスライドが出る）
- 箇条書きは `-` で始め、1段下げるときは半角スペース4つで字下げする
- 色の強調・表・数式・図の置き方は、`slide.qmd` の見本と [SlideRules.md](SlideRules.md) を見る
- 作る順番（何から決めるか）は [workflow.md](workflow.md)
- 文献：`ref.bib` に BibTeX 形式で書き、本文では `\textcite{キー}` や `\parencite{キー}` で引用する
- 図：`figures` フォルダを作って画像を置き、`\includegraphics[width=\linewidth]{figures/ファイル名.png}` で貼る
- よくある応用（Outline を消す、論文と同じ `.bib` を使う、色を変える、共著者を書く）は [recipes.md](recipes.md)

---

## 6. テンプレートの更新を取り込む

テンプレートが更新されたら（管理者から連絡します）、まず手元のコピーを最新にします。

```bash
cd ~/koyama-beamer
git pull
```

これで、**これから作るスライド**は新しい版になります。

**作りかけのスライド**にも新しい版を入れたいときは、そのスライドのフォルダで次を打ちます。

```bash
cd <研究のフォルダ>/report/slide
quarto add <koyama-beamer のパス>
```

v2 のスライドなら `quarto add <koyama-beamer のパス>/v2` です。

「`[Update] 1.0.0 -> 1.1.0`」のように表示されます。続けてよいか聞かれたら `y` で進めると入れ替わります。

> **更新する前に [CHANGELOG.md](../CHANGELOG.md) を見てください。** 版によって命令や色の名前が変わることがあり、
> そのままではエラーになったり見た目が変わったりします（例：1.1.0 で `mainred` → `accent` に変更）。
> **発表が終わったスライドは更新しない**でください。各スライドのフォルダには作ったときの版が入っているので、
> 更新しなければ、あとで開き直しても同じ見た目でビルドできます。

---

## 困ったとき

| 症状 | 原因と対処 |
|---|---|
| `git` や `quarto` が「見つからない」と言われる | ソフトを入れたあと、ターミナルを開き直していない。閉じて開き直す |
| `git clone` で `Repository not found` や `403` | 招待をまだ承認していない（手順 1）か、別のアカウントでログインしている |
| `git clone` で `Permission denied (publickey)` | SSH の URL を使ったが鍵が未登録。手順 3 の `https://` の URL を使う |
| `quarto check` で LaTeX が見つからない | `quarto install tinytex` をもう一度打ち、ターミナルを開き直す |
| `Font "Noto Sans JP" not found` などのエラー | フォントが入っていない、または `static` フォルダのファイルを入れていない（手順 2.4） |
| PDF はできるが太字にならない | `NotoSansJP-SemiBold.ttf` が入っていない（手順 2.4 の `static` をすべて入れる） |
| 文献が `[key]` や太字のキーのまま表示される | `ref.bib` のキーの綴りの誤り、または YAML の `bib-file:` のパスの誤り |
| 先頭に空白のスライドが出る | 本文の最初が `#` の行になっていない（手順 5.3） |
| 更新したらエラーになった | 版で命令の名前が変わった。CHANGELOG の該当する版を見て書き換える |

解決しないときは、エラーの画面（ターミナルの最後の数十行）をコピーして管理者に送ってください。
GitHub のリポジトリの「Issues」に書いてもらってもかまいません。

---

## （参考）足りない LaTeX の部品を手で入れる

通常は不要です（初めてのビルドで自動で入ります）。自動で入らなかったときだけ、TinyTeX の `tlmgr` で入れます。
TinyTeX はターミナルの検索先（PATH）に入らないので、フルパスで打ちます。

```bash
# Windows（Git Bash）
"$APPDATA/TinyTeX/bin/windows/tlmgr.bat" install beamertheme-metropolis pgfopts noto fontaxes mweights luatexja tcolorbox environ trimspaces pgfplots biblatex biblatex-apa biber csquotes appendixnumberbeamer multirow colortbl caption tools booktabs xurl bookmark
```

macOS では、TinyTeX は `~/Library/TinyTeX` に入ります（未確認）。
