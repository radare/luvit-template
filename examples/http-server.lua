#!/usr/bin/env luvit
-- http server example using Template for luvit --
local Url = require('url')
local HTTP = require("http")
local Utils = require("utils")
local Template = require("template")
local QueryString = require('querystring')

local env = {
	-- XXX
	name = "jeje"
}

HTTP.create_server("0.0.0.0", 8080, function (req, res)
	p ("on_request", req)
	local chunks = ""
	req:on ('data', function (chunk, len)
		chunks = chunks .. chunk
	end)
	req:on ('end', function ()
		--local body = Table.concat(chunks, "")
		local body=chunks
		if body == "" then return end
		query={}

		local x = QueryString.parse (body)
		env.name = x.name
		body = "Thanks for watching!<br/><br />length = " .. #x.name .. "<br /><br />\n"
		body = body .."YOUR NAME IS : "..x.name.."<br /><br />"
		body = body .."<a href=/>back</a>"
		p("on_end", {total_len=#body})
		res:write_head(200, {
			["Content-Type"] = "text/html",
			["Content-Length"] = #body
		})
		res:finish(body)
	end)

	req.uri = Url.parse(req.url)
	if req.method == "POST" then
		print ("POST")
		p(req.uri.query)
	else
		Template.render_file ("www/index.luahtml", env, function (err, body)
	--Template.render_file ("www/test.luahtml", env, function (err, body)
		p(err)
		p(req)
	--Utils.dump({req=req,headers=req.headers}) .. "\n"
		res:write_head(200, {
			["Content-Type"] = "text/html",
			["Content-Length"] = #body
		})
		res:finish(body)
	end)
end
end)

print ("Server listening at http://localhost:8080/")
