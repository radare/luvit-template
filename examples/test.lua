#!/usr/bin/env luvit
--
-- template system for luvit --
--

local Template = require ("template")
local FS = require ('fs')

if 1 == 0 then
function doread (fd, n)
	local bs = 4096
	FS.read (fd, n, n+bs, function (err, chunk)
		if (chunk == "" or err) then
			FS.close (fd, nil)
		else
			print (Template.render (chunk))
			doread (fd, n + bs)
		end
	end)
end

FS.open ("test.tmpl", 'r', 0644, function (err, fd)
	if (err) then return end
	local t = Template.compiler (fd, function (x)
		-- do stuff here
		print (x)
	end)
	doread (fd, 0)
end)

FS.read_file ("test.tmpl", function (err, data)
	print (Template.render (data))
end)
end

env = {
	name = "pancake",
	age = 28
}

Template.render_file ("test.tmpl", env, function (err, data)
	p (err)
	print (data)
end)
