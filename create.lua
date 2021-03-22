local hashids = require('hashids').new('zttl')

local NOTE_TPL = [[---
id: %s
date: %s
title: %s
tags:
- tag
---
# Heading]]

local function handler(parsed, command, app)
  local id = hashids:encode(os.time(os.date('!*t')))
  local date = os.date('%Y-%m-%d')
  local tmp_path = os.tmpname()
  local path = ('%s/%s.md'):format(NOTES_FOLDER, id)
  io.writefile(tmp_path, NOTE_TPL:format(id, date, parsed.args:join(' ')))
  os.execute(('cat %s | nvim - +"f %s"'):format(tmp_path, path))
  os.remove(tmp_path)
end

return function(app)
  app:command('create [args...]', 'create a note')
    :action(handler)
end
