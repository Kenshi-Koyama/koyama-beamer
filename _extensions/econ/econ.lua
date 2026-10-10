-- econ.lua
-- YAML の切り替えオプションを読み、設定マクロ → beamer-preamble.tex の順でヘッダに入れる。
-- （順番を固定するため、プリアンブルは _extension.yml の include-in-header ではなくここで入れる）
--
-- 使えるオプション（スライドの YAML の最上位に書く）
--   section-outline: false   各セクション冒頭の Outline スライドを入れない（短い発表用）
--   bib-file: ../paper/refs.bib   文献ファイル（既定は同じフォルダの ref.bib）

local function opt_bool(meta, key, default)
  local v = meta[key]
  if v == nil then return default end
  if type(v) == "boolean" then return v end
  local s = pandoc.utils.stringify(v)
  return not (s == "false" or s == "no")
end

function Meta(meta)
  if not quarto.doc.is_format("beamer") then return meta end

  local config = {}
  if not opt_bool(meta, "section-outline", true) then
    table.insert(config, "\\def\\econNoSectionOutline{}")
  end
  local bib = "ref.bib"
  if meta["bib-file"] ~= nil then bib = pandoc.utils.stringify(meta["bib-file"]) end
  table.insert(config, "\\def\\econBibFile{" .. bib .. "}")

  quarto.doc.include_text("in-header", table.concat(config, "\n"))
  quarto.doc.include_file("in-header", quarto.utils.resolve_path("beamer-preamble.tex"))
  return meta
end
