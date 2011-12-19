#!/usr/bin/env luvit
--
-- template system for luvit --
--

local Template = require ("template")
local FS = require ('fs')


local test = [[
FOO
<?= "blob" ?>
BAR <?= "boniato"?> jijiij :D
<?= env.name ?>
So this is cool.. lets try that: <?  a = 3; if a == 3 then ?> pirindula <?  end ?>
]]

env = {
	name = "pancake",
	age = 28
}

err, data = Template.render (test, env)
if err then
	print ("error: "+data)
else
	print (data)
end

print ("-----")

env.name="boniato"

Template.render_file ("test.tmpl", env, function (err, data)
	p (err)
	print (data)
end)
