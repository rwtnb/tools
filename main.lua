#!/usr/bin/env lua
local version = _VERSION:match("%d+%.%d+")
local base_path = string.gsub(arg[0], '/%w+.%w+$', '', 1)
package.path = base_path ..'/?.lua;' .. base_path .. '/lua_modules/share/lua/' .. version .. '/?.lua;lua_modules/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = base_path .. '/lua_modules/lib/lua/' .. version .. '/?.so;' .. package.cpath

require 'polyfill'
require 'logging.console'

local lummander = require 'lummander'
local yaml = require 'lyaml'
local log = logging.console()
local lfs = require 'lfs'
local hid = require('hashids').new('zttl')
local WIKI_FOLDER = '/share/wiki'
local NOTE_TPL = [[---
id: %s
title: Untitled
date: %s
tags:
- tag
---
# Heading]]

local function write_index(items)
	local index_path = WIKI_FOLDER..'/index.md'
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

local function reindex()
	local items = {}
	for file in lfs.dir(WIKI_FOLDER) do
		local full_path = WIKI_FOLDER..'/'..file
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

local function new()
	local id = hid:encode(os.time(os.date('!*t')))
	local date = os.date('%Y-%m-%d')
	local tmp_path = os.tmpname()
	local path = ('%s/%s.md'):format(WIKI_FOLDER, id)
	io.writefile(tmp_path, NOTE_TPL:format(id, date))
	os.execute(('cat %s | nvim - +"f %s"'):format(tmp_path, path))
	os.remove(tmp_path)
	reindex()
end

local cli = lummander.new {
	title = 'zttl',
	description = 'zettelkasten helper',
	version = '0.1',
	author = 'rwtnb',
}

cli:command('reindex', 'rebuild index')
	:action(reindex)

cli:command('new', 'create a note')
	:action(new)

cli:parse(arg)
