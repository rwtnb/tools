package = "zttl"
version = "0.1-1"
rockspec_format = "3.0"
source = {
	url = "git://github.com/rwtnb/zttl",
	tag = "master",
}
description = {
	summary = "A markdown based note taking program",
	detailed = [[
		`zttl` aims to make it easy to create a markdown based
		note collections that are easy to search and manage.
	]],
	homepage = "https://github.com/rwtnb/zttl",
	license = "MIT",
}
dependencies = {
	"lua >= 5.1",
	"lyaml >= 5.2.7-1",
	"lummander >= 0.1.0-2",
	"lualogging >= 1.1.4-1",
	"luafilesystem >= 1.8.0-1",
	"hashids >= 1.0.6-1",
}
