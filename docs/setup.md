# 環境構築（初回だけ）

Windows で動作を確認している（Quarto 1.9.37 + TinyTeX）。macOS / Linux でも同じ手順で動くはずだが未確認。

## 1. Quarto

<https://quarto.org/docs/get-started/> からインストール。確認：

```bash
quarto --version
```

## 2. TinyTeX（LaTeX）

```bash
quarto install tinytex
```

初めてレンダリングしたときに、足りない LaTeX パッケージは自動で入る。
自動で入らないときは、主に次のパッケージを手で入れる（`tlmgr install …`。Windows では `tlmgr.bat`）：

```
beamer beamertheme-metropolis pgfopts noto fontaxes mweights luatexja
tcolorbox environ trimspaces pgfplots biblatex biblatex-apa biber csquotes
appendixnumberbeamer multirow colortbl caption tools booktabs xurl bookmark
```

## 3. フォント（Noto Sans JP）

日本語は **Noto Sans JP** を使う（欧文の Noto Sans は LaTeX の `noto` パッケージに含まれる）。
OS に入っていなければ <https://fonts.google.com/noto/specimen/Noto+Sans+JP> から入れる。
Medium と SemiBold のウェイトを使うので、可変フォントではなく全ウェイトを入れる。

## 4. 動作確認

このリポジトリで見本をレンダリングする：

```bash
quarto render template.qmd
```

`template.pdf` ができ、日本語が Noto Sans JP で表示され、太字が効いていれば OK。

## うまくいかないとき

| 症状 | 原因と対処 |
|---|---|
| `Font "Noto Sans JP" not found` | フォントが OS に入っていない（3.）。入れた直後は `luaotfload-tool --update` |
| 太字にならない | Noto Sans JP の SemiBold が入っていない |
| 文献が `[key]` のまま | `.bib` のキーの綴り、または `bib-file` のパスの誤り |
| 先頭に空白のスライドが出る | 本文の最初が `#` 見出しになっていない（前に地の文やコメントがある） |
