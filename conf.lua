--[[
	Sling Hoops
]]--

love.filesystem.setIdentity("slhoops");

function love.conf(t)
	t.console = true;
	t.title = "Cannon Pop";
	t.window.width = 800;
	t.window.height = 480;
	t.window.fullscreen = true;
	t.window.vsync = false;
	t.window.borderless = false;
	t.author = "Aaron Skinner";
end
