-- knitr may split one echoed cell around its console output. Without grouping,
-- Quarto would create several listings with the same anchor and different numbers.
-- Reunite only those source blocks, keeping their results after the code listing.
local function reunite_source(div)
  if not div.classes:includes('cell') then return nil end
  local code_blocks = {}
  for _, block in ipairs(div.content) do
    if block.t == 'CodeBlock' and block.identifier:match('^lst%-') then
      table.insert(code_blocks, block)
    end
  end
  if #code_blocks < 2 then return nil end
  local first = code_blocks[1]
  local text = {}
  for _, code in ipairs(code_blocks) do
    if code.identifier ~= first.identifier then return nil end
    table.insert(text, code.text)
  end
  local combined = pandoc.CodeBlock(table.concat(text, '\n'), first.attr)
  local content = pandoc.Blocks({})
  local inserted = false
  for _, block in ipairs(div.content) do
    if block.t == 'CodeBlock' and block.identifier == first.identifier then
      if not inserted then content:insert(combined); inserted = true end
    else
      content:insert(block)
    end
  end
  div.content = content
  return div
end

-- Quarto normally promotes a cell's filename to its direct code child. Retain
-- that header when the listing div or Map separation changes this structure.
local function retain_filename(div)
  local filename = div.attributes['filename']
  if filename and div.classes:includes('cell') then
    return div:walk({CodeBlock = function(code)
      if code.identifier:match('^lst%-') then
        code.attributes['filename'] = filename
        return code
      end
    end})
  end
end

-- Quarto 1.10 cannot parse an empty lst-cap on an undecorated CodeBlock.
-- Express it as an equivalent blank-caption listing div instead.
local function blank_listing(code)
  if code.identifier:match('^lst%-') and code.attributes['lst-cap'] == '' then
    local id = code.identifier
    code.identifier = ''
    code.attributes['lst-cap'] = nil
    return pandoc.Div({code}, pandoc.Attr(id))
  end
end

-- A listing inside a Map would become a subfloat labelled (a), not Code N.N.
-- Lift the visible code out of the Map before Quarto builds the floats.
local function separate_map_code(div)
  if not div.identifier:match('^map%-') then return nil end
  local listings = pandoc.Blocks({})
  div = div:walk({
    Div = function(el)
      if el.identifier:match('^lst%-') then
        listings:insert(el)
        return pandoc.Blocks({}), false
      end
    end,
    CodeBlock = function(el)
      if el.identifier:match('^lst%-') then
        listings:insert(el)
        return pandoc.Blocks({})
      end
    end
  })
  if #listings == 0 then return div end
  listings:insert(div)
  return listings
end

return {{Div = reunite_source}, {Div = retain_filename}, {CodeBlock = blank_listing}, {Div = separate_map_code}}
