#!/usr/bin/env lua
local version = _VERSION:match("%d+%.%d+")
local base_path = string.gsub(arg[0], '/%w+.%w+$', '', 1)
package.path = base_path ..'/?.lua;' .. base_path .. '/lua_modules/share/lua/' .. version .. '/?.lua;lua_modules/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = base_path .. '/lua_modules/lib/lua/' .. version .. '/?.so;' .. package.cpath

NOTES_FOLDER = '/share/wiki'

local lummander = require 'lummander'

local app = lummander.new {
  title = 'zttl',
  description = 'zettelkasten helper',
  version = '0.1',
  author = 'rwtnb',
}

require('create')(app)
require('reindex')(app)

app:parse(arg)
