require 'polyfill'
require 'logging.console'

local log = logging.console()
local yaml = require 'lyaml'
local lfs = require 'lfs'

local function write_index(items)
  local index_path = NOTES_FOLDER..'/index.md'
  local file = io.open(index_path, 'w')
  for _, m in ipairs(items) do
    local tags = {}
    for _, t in ipairs(m.tags) do table.insert(tags, ('*%s*'):format(t)) end
    local title = string.padright(m.title, '.', 50)
    local joined_tags = table.join(tags, ' ')
    local text = string.format('%s [[%s.md|%s]] %s %s\n', m.date, m.id, m.id, title, joined_tags)
    file:write(text)
  end
  file:close()
end

local function read_metadata(fpath)
  local contents = io.readfile(fpath)
  local buffers = contents:split('---')
  if buffers[1] == nil then return end
  return yaml.load(buffers[1])
end

local function handler(parsed, command, app)
  local items = {}
  for file in lfs.dir(NOTES_FOLDER) do
    local full_path = NOTES_FOLDER..'/'..file
    if lfs.attributes(full_path, 'mode') == 'file' and file ~= 'index.md' then
      local metadata = read_metadata(full_path)
      if metadata ~= nil then
        table.insert(items, metadata)
      else
        log:warn('metadata missing on '..file)
      end
    end
  end
  write_index(items)
end

return function(app)
  app:command('reindex', 'rebuild index')
    :action(handler)
end
