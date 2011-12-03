Template
========
Author: pancake<nopcode.org>

Description
-----------
This is a template module for luvit.

The current implementation is not completely asynchronous, and 
it is still experimental.

Example
-------
This is an example of the luvit Template api:

	$ cat test.tmpl
	FOO <?= "blob" ?>
	BAR <?= "borni" ?> jijiij :D

	So this is cool.. lets try that: <?
	a = 3; if a == 3 then ?> everything worked fine <?  end ?>
	
	$ cat test.lua
	Template.render_file ("test.tmpl", function (err, data)
		p (err)
		print (data)
	end)
