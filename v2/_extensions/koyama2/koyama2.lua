-- koyama2.lua（v2。v1 の koyama.lua から複製）
-- YAML の切り替えオプションを読み、設定マクロ → beamer-preamble.tex の順でヘッダに入れる。
-- （順番を固定するため、プリアンブルは _extension.yml の include-in-header ではなくここで入れる）
--
-- 使えるオプション（スライドの YAML の最上位に書く）
--   section-outline: false        各セクション冒頭の目次スライドを入れない（短い発表用）
--   bib-file: ../paper/refs.bib   文献ファイル（既定は同じフォルダの ref.bib）
--   palette:                      色の差し替え（16進。書かなかった色は既定のまま）
--     primary: "1F4E79"
--   event: 医療経済学会 第21回研究大会   表紙の右上の学会名
--   venue: 東京大学                     表紙の日付のあとに「@会場」
--   shorttitle: 短いタイトル            目次スライドの左上（無ければ title）
--   author:                             表紙に名前と所属を横に並べる。presenter: true の人に *
--     - name: 小山 拳志
--       affiliation: The University of Osaka
--       presenter: true
--
-- 本文の変換
--   箇条書きで「太字だけの項目」の下に子の箇条書きがあるとき（例: - **Data** の下に - …）、
--   その項目は見出しとして扱い、記号（●）を付けずに左端から書く。子の箇条書きは1段上げる
--   （見出しの下に、1段目の箇条書きとして並ぶ）。2つ目以降の見出しの前には空きを入れる。
--   項目が矢印（→ ⇒ / $\to$ $\Rightarrow$ など）で始まるときは、● の代わりにその矢印を記号の位置に置く。
--   ::: defbox … ::: は \begin{defbox} … \end{defbox} にする（中は Markdown で書ける）。
--   \printbibliography のあるスライドは、タイトルの左の四角に番号を書かない（\koyamaNoSectionNumber）。

local palette_names = {
  textmain = true, textmuted = true, textlight = true, textfaint = true,
  primary = true, primarylight = true, accent = true, accentlight = true, highlight = true,
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
  { base = "primary", light = "primarylight", mix = "20" },
  { base = "accent", light = "accentlight", mix = "28" },
}
local function palette_config(meta)
  local out = {}
  if meta.palette == nil then return out end
  local given = {}
  for name, value in pairs(meta.palette) do
    local hex = pandoc.utils.stringify(value):gsub("^#", ""):upper()
    if not palette_names[name] then
      quarto.log.warning("koyama2: palette の色名 '" .. name .. "' は使えない（無視した）")
    elseif not hex:match("^%x%x%x%x%x%x$") then
      quarto.log.warning("koyama2: palette の " .. name .. " は 6桁の16進で書く（無視した）: " .. hex)
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


-- メタデータの値を LaTeX の文字列にする（文字列・インラインのどちらでも）
local function to_latex(v)
  if v == nil then return "" end
  local t = pandoc.utils.type(v)
  local inl
  if t == "Inlines" then
    inl = v
  elseif t == "Blocks" then
    return (pandoc.write(pandoc.Pandoc(v), "latex"):gsub("%s+$", ""))
  else
    inl = pandoc.Inlines({ pandoc.Str(pandoc.utils.stringify(v)) })
  end
  return (pandoc.write(pandoc.Pandoc({ pandoc.Plain(inl) }), "latex"):gsub("%s+$", ""))
end

-- 表紙の著者：Quarto が正規化した by-author から、名前・所属・発表者の印を取り出す
local function authors_config(meta)
  local list = meta["by-author"]
  if list == nil or #list == 0 then return {} end
  local items = {}
  for _, a in ipairs(list) do
    local name = ""
    if a.name ~= nil then
      name = to_latex(a.name.literal or a.name)
    end
    local affs = {}
    if a.affiliations ~= nil then
      for _, af in ipairs(a.affiliations) do
        if af.name ~= nil then table.insert(affs, to_latex(af.name)) end
      end
    end
    if #affs == 0 and #list == 1 and meta.institute ~= nil then
      table.insert(affs, to_latex(meta.institute))
    end
    local presenter = "0"
    if a.metadata ~= nil and a.metadata.presenter ~= nil
       and pandoc.utils.stringify(a.metadata.presenter) == "true" then
      presenter = "1"
    end
    table.insert(items, "\\koyamaAuthor{" .. name .. "}{" .. table.concat(affs, ", ") .. "}{" .. presenter .. "}")
  end
  return {
    "\\def\\koyamaAuthorCount{" .. #items .. "}",
    "\\def\\koyamaAuthors{" .. table.concat(items, "%\n  ") .. "}",
  }
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
  if meta.event ~= nil then table.insert(config, "\\def\\koyamaEvent{" .. to_latex(meta.event) .. "}") end
  if meta.venue ~= nil then table.insert(config, "\\def\\koyamaVenue{" .. to_latex(meta.venue) .. "}") end
  for _, line in ipairs(authors_config(meta)) do table.insert(config, line) end

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
    local b = item[i]
    if b.t == "BulletList" or b.t == "OrderedList" then return true end
    -- 子の箇条書きが先に（矢印の差し替えで）LaTeX に組み立て済みの場合
    if b.t == "RawBlock" and b.text:match("^\\begin{itemize}") then return true end
  end
  return false
end

-- 矢印で始まる項目か。そうなら先頭の矢印を本文から取り除き、記号の位置に置く LaTeX を返す
-- （「● →」と記号が2つ並ばないように。→ / ⇒ の文字と、$\to$ などの数式の両方に対応）
local arrow_math = { ["\\to"] = true, ["\\rightarrow"] = true, ["\\Rightarrow"] = true, ["\\implies"] = true }
local arrow_chars = { "→", "⇒" }

local function take_arrow(item)
  local first = item[1]
  if first == nil or (first.t ~= "Plain" and first.t ~= "Para") then return nil end
  local inl = first.content
  local head = inl[1]
  if head == nil then return nil end
  local label = nil
  if head.t == "Math" and head.mathtype == "InlineMath" then
    local m = head.text:gsub("^%s+", ""):gsub("%s+$", "")
    if arrow_math[m] then
      label = "$" .. m .. "$"
      inl:remove(1)
    end
  elseif head.t == "Str" then
    for _, c in ipairs(arrow_chars) do
      if head.text:sub(1, #c) == c then
        label = c
        local rest = head.text:sub(#c + 1)
        if rest == "" then inl:remove(1) else head.text = rest end
        break
      end
    end
  end
  if label == nil then return nil end
  while inl[1] ~= nil and (inl[1].t == "Space" or inl[1].t == "SoftBreak") do inl:remove(1) end
  return "{\\color{textmain}" .. label .. "}"
end

-- 項目の並びを itemize にする。矢印で始まる項目があれば、その項目だけ \item[矢印] にする
-- （矢印の項目がなければ pandoc の通常の箇条書きのまま返す）
local function build_list(items)
  local marks = {}
  local has_arrow = false
  for i, item in ipairs(items) do
    local arrow = take_arrow(item)
    if arrow ~= nil then
      marks[i] = "\\item[" .. arrow .. "] "
      has_arrow = true
    else
      marks[i] = "\\item "
    end
  end
  if not has_arrow then return { pandoc.BulletList(items) } end

  local tight = items[1][1] ~= nil and items[1][1].t == "Plain"
  local blocks = { pandoc.RawBlock("latex", "\\begin{itemize}" .. (tight and "\n\\tightlist" or "")) }
  for i, item in ipairs(items) do
    local first = item[1]
    if first ~= nil and (first.t == "Plain" or first.t == "Para") then
      first.content:insert(1, pandoc.RawInline("latex", marks[i]))
    else
      table.insert(blocks, pandoc.RawBlock("latex", marks[i]))
    end
    for _, b in ipairs(item) do table.insert(blocks, b) end
  end
  table.insert(blocks, pandoc.RawBlock("latex", "\\end{itemize}"))
  return blocks
end

-- 箇条書きの記号を差し替える
--   太字の見出し項目 → 箇条書きから外して左端の太字の行にし、その子の箇条書きを1段上げる
--   矢印で始まる項目 → ● の代わりに矢印（build_list）
function BulletList(el)
  if not quarto.doc.is_format("beamer") then return nil end
  local has_heading = false
  for _, item in ipairs(el.content) do
    if is_heading_item(item) then has_heading = true end
  end
  if not has_heading then
    local blocks = build_list(el.content)
    if blocks[1].t == "BulletList" then return nil end
    return blocks
  end

  local out = {}
  local pending = {}
  local function flush()
    if #pending > 0 then
      for _, b in ipairs(build_list(pending)) do table.insert(out, b) end
      pending = {}
    end
  end
  for _, item in ipairs(el.content) do
    if is_heading_item(item) then
      flush()
      -- 2つ目以降の見出しの前には空きを入れる（まとまりを区切る）
      if #out > 0 then table.insert(out, pandoc.RawBlock("latex", "\\koyamaListGap")) end
      -- 太字の中身を \koyamaListHead{...} で包む（プリアンブルで定義。見出しの下の空きを詰める）
      local head = pandoc.Inlines({ pandoc.RawInline("latex", "\\koyamaListHead{") })
      head:extend(item[1].content[1].content)
      head:insert(pandoc.RawInline("latex", "}"))
      table.insert(out, pandoc.Plain(head))
      for i = 2, #item do table.insert(out, item[i]) end
    else
      table.insert(pending, item)
    end
  end
  flush()
  return out
end

-- ::: defbox … ::: を defbox 環境にする（中の箇条書きは上の BulletList で変換済み）
function Div(el)
  if not quarto.doc.is_format("beamer") then return nil end
  if not el.classes:includes("defbox") then return nil end
  local out = { pandoc.RawBlock("latex", "\\begin{defbox}") }
  for _, b in ipairs(el.content) do table.insert(out, b) end
  table.insert(out, pandoc.RawBlock("latex", "\\end{defbox}"))
  return out
end

-- \printbibliography を含むブロックか
local function has_bibliography(block)
  local found = false
  local function check(raw)
    if raw.text:match("\\printbibliography") then found = true end
  end
  if block.t == "RawBlock" then
    check(block)
  else
    pandoc.walk_block(pandoc.Div({ block }), { RawBlock = check, RawInline = check })
  end
  return found
end

-- 文献リストのスライド（\printbibliography のある ## のスライド）は、四角に番号を書かない
function Pandoc(doc)
  if not quarto.doc.is_format("beamer") then return nil end
  local slide = nil
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" and b.level <= 2 then
      slide = (b.level == 2) and b or nil
    elseif slide ~= nil and has_bibliography(b) then
      slide.content:insert(1, pandoc.RawInline("latex", "\\koyamaNoSectionNumber{}"))
      slide = nil
    end
  end
  return doc
end
