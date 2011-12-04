-- Asyncrunous template system for luvit
-- 2011 -- LGPLv2 -- work in progress -- pancake<nopcode.org>

local FS = require ('fs')

local Template = {}

local function append(x,y,s)
	return x.."data = data .. "..s..y:gsub("\n", "\\n")..s.."\n"
end

function Template.render(x,env)
	local body = "local data = ''\n"
	B = x
	repeat
		f = x:find ("<%?")
		if not f then break end
		A = x:sub (0, f-1)
		B = x:sub (f+2, -1)
		body = append (body, A, "'")
		g = B:find ("%?>")
		if g then
			local ch = B:sub (0, 1)
			if ch == '=' then
				local str = B:sub (2, g-1)
					:gsub ("<", "&lt;")
					:gsub (">", "&gt;")
				body = append (body, str, '')
			elseif ch == '-' then
				body = append (body, B:sub (2, g-1), '')
			else
				body = body.. B:sub (0,g-1).."\n"
			end
			B = B:sub (g+2, -1)
		end
		x = B
	until f<0
	if B then body = append (body, B, "'") end
	--local oldenv-- TODO
	_G.env = env -- make it global
	-- print (body)
	local a,b = loadstring (body.."\nreturn data")
	if b then return true, b end
	return false, a()
end

function Template.render_file(x,e,y)
	FS.read_file (x, function (err, data)
		if (err) then
			y (true, err.message)
		else
			local err, out = Template.render (data, e)
			y (err, out)
		end
	end)
end

-- asynchronous read
function Template.compiler(e,f)
	-- TODO
	local obj = {
		fd = f,
		env = e,
		data = "",
		parse = function ()
			print "parsing.."
		end
	}
	return obj
end

-- local tc = Template.compiler (

function Template.pipe(i, o)
	-- TODO
	-- read from in
	-- parse and write to out
end

return Template
