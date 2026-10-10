-- koyama.lua
-- YAML の切り替えオプションを読み、設定マクロ → beamer-preamble.tex の順でヘッダに入れる。
-- （順番を固定するため、プリアンブルは _extension.yml の include-in-header ではなくここで入れる）
--
-- 使えるオプション（スライドの YAML の最上位に書く）
--   section-outline: false        各セクション冒頭の Outline スライドを入れない（短い発表用）
--   bib-file: ../paper/refs.bib   文献ファイル（既定は同じフォルダの ref.bib）
--   palette:                      色の差し替え（16進。書かなかった色は既定のまま）
--     primary: "1F4E79"
--
-- 本文の変換
--   箇条書きで「太字だけの項目」の下に子の箇条書きがあるとき（例: - **Data** の下に - …）、
--   その項目は見出しとして扱い、記号（●）を付けない。

local palette_names = {
  textmain = true, textmuted = true, primary = true, primarylight = true,
  accent = true, accentlight = true, highlight = true,
}

local function opt_bool(meta, key, default)
  local v = meta[key]
  if v == nil then return default end
  if type(v) == "boolean" then return v end
  local s = pandoc.utils.stringify(v)
  return not (s == "false" or s == "no")
end

-- 主色だけ差し替えたとき、淡い色を主色から自動で作る（既定の淡い色とほぼ同じ混ぜ具合）
local derived = {
  { base = "primary", light = "primarylight", mix = "12" },
  { base = "accent", light = "accentlight", mix = "35" },
}

local function palette_config(meta)
  local out = {}
  if meta.palette == nil then return out end
  local given = {}
  for name, value in pairs(meta.palette) do
    local hex = pandoc.utils.stringify(value):gsub("^#", ""):upper()
    if not palette_names[name] then
      quarto.log.warning("koyama: palette の色名 '" .. name .. "' は使えない（無視した）")
    elseif not hex:match("^%x%x%x%x%x%x$") then
      quarto.log.warning("koyama: palette の " .. name .. " は 6桁の16進で書く（無視した）: " .. hex)
    else
      table.insert(out, "\\definecolor{" .. name .. "}{HTML}{" .. hex .. "}")
      given[name] = true
    end
  end
  table.sort(out)
  for _, d in ipairs(derived) do
    if given[d.base] and not given[d.light] then
      table.insert(out, "\\colorlet{" .. d.light .. "}{" .. d.base .. "!" .. d.mix .. "!white}")
    end
  end
  return out
end

function Meta(meta)
  if not quarto.doc.is_format("beamer") then return meta end

  local config = palette_config(meta)
  if not opt_bool(meta, "section-outline", true) then
    table.insert(config, "\\def\\koyamaNoSectionOutline{}")
  end
  local bib = "ref.bib"
  if meta["bib-file"] ~= nil then bib = pandoc.utils.stringify(meta["bib-file"]) end
  table.insert(config, "\\def\\koyamaBibFile{" .. bib .. "}")

  quarto.doc.include_text("in-header", table.concat(config, "\n"))
  quarto.doc.include_file("in-header", quarto.utils.resolve_path("beamer-preamble.tex"))
  return meta
end

-- 「太字だけ」の項目で、その下に子の箇条書きがあるか
local function is_heading_item(item)
  local first = item[1]
  if first == nil or (first.t ~= "Plain" and first.t ~= "Para") then return false end
  local inl = first.content
  local n = #inl
  while n > 0 and (inl[n].t == "Space" or inl[n].t == "SoftBreak") do n = n - 1 end
  if n ~= 1 or inl[1].t ~= "Strong" then return false end
  for i = 2, #item do
    if item[i].t == "BulletList" or item[i].t == "OrderedList" then return true end
  end
  return false
end

-- 見出し項目を含む箇条書きだけ、itemize を自分で組み立てて見出し項目を \item[] にする
function BulletList(el)
  if not quarto.doc.is_format("beamer") then return nil end
  local has_heading = false
  for _, item in ipairs(el.content) do
    if is_heading_item(item) then has_heading = true end
  end
  if not has_heading then return nil end

  local tight = el.content[1][1] ~= nil and el.content[1][1].t == "Plain"
  local blocks = { pandoc.RawBlock("latex", "\\begin{itemize}" .. (tight and "\n\\tightlist" or "")) }
  for _, item in ipairs(el.content) do
    local mark = is_heading_item(item) and "\\item[] " or "\\item "
    local first = item[1]
    if first ~= nil and (first.t == "Plain" or first.t == "Para") then
      first.content:insert(1, pandoc.RawInline("latex", mark))
      for _, b in ipairs(item) do table.insert(blocks, b) end
    else
      table.insert(blocks, pandoc.RawBlock("latex", mark))
      for _, b in ipairs(item) do table.insert(blocks, b) end
    end
  end
  table.insert(blocks, pandoc.RawBlock("latex", "\\end{itemize}"))
  return blocks
end
