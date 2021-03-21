local hashids = require('hashids').new('zttl')

local NOTE_TPL = [[---
id: %s
date: %s
title: %s
tags:
- %s
---
# Heading]]

local function handler(parsed, command, app)
  local id = hashids:encode(os.time(os.date('!*t')))
  local date = os.date('%Y-%m-%d')
  local tmp_path = os.tmpname()
  local path = ('%s/%s.md'):format(NOTES_FOLDER, id)
  local tags = table.join(parsed.tags, "\n- ")
  io.writefile(tmp_path, NOTE_TPL:format(id, date, parsed.title, tags))
  os.execute(('cat %s | nvim - +"f %s"'):format(tmp_path, path))
  os.remove(tmp_path)
end

return function(app)
  app:command('create <title> [tags...]', 'create a note')
    :action(handler)
end
