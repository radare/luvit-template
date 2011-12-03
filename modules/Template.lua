-- Asyncrunous template system for luvit
-- 2011 -- LGPLv2 -- work in progress -- pancake<nopcode.org>

local FS = require ('fs')

local function append(x,y,s)
	return x.."data = data .. "..s..y:gsub("\n", "\\n")..s.."\n"
end

local function _render(x,env)
	local body = "local data = ''\n"
	repeat
		f = x:find ("<\\?")
		if not f then break end
		A = x:sub (0, f-1)
		B = x:sub (f+2, -1)
		body = append (body, A, "'")
		g = B:find ("\\?>")
		if g then
			if (B:sub(0,1) == '=') then
				body = append (body, B:sub (2, g-2), '')
			else
				body = body.. B:sub (0,g-2)
			end
			B = B:sub (g+2, -1)
		end
		x = B
	until f<0
	if B then body = append (body, B, "'") end
	local oldenv
	_G.env = env -- make it global
	local a,b = loadstring (body.."\nreturn data")
	if b then return true, b end
	return false, a()
end

local function _render_file(x,e,y)
	FS.read_file (x, function (err, data)
		if (err) then
			y (true, err.message)
		else
			local err, out = _render (data, e)
			y (false, out)
		end
	end)
end

-- asyncrunous read
local function _compiler(f, x)
	-- TODO
	local obj = {
		fd = f, 
		data = x,
		parse = function ()
			print "parsing.."
		end
	}
	return obj
end

local function _pipe(i, o)
	-- TODO
	-- read from in
	-- parse and write to out
end

return {
	compiler = _compiler,
	render_file = _render_file,
	pipe = _pipe,
	render = _render,
}
