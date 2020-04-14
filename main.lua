--[[
	Sling Hoops
	APPID: ca-app-pub-7062123763561644~5335799307
]]--

SLING = {
	__VERSION = "0.0.1",
	__AUTHOR = "Aaron Skinner",
	__DEBUG = true,
	__FPS = 60,
	__COMPILE = true,

	-- Settings
	Settings = {
		Meter = 64,
		WorldRes = 0
	},

	FirstLoad = true,

	Mode = 2,

	MaxLevels = 50
}

-- Setup Ads if compiling an APK to run!
if( SLING.__COMPILE ) then
	-- CHANGE THESE TO REAL ADS PLS
	love.ads.createBanner("ca-app-pub-7062123763561644/9083472629", "bottom");
	love.ads.requestInterstitial("ca-app-pub-7062123763561644/5144227616");
	love.ads.requestRewardedAd("ca-app-pub-7062123763561644/6784929570");

end

SLING.ui = {}
SLING.ui.buttons = {}
SLING.ui.labels = {}
SLING.ui.panels = {}

function ctype(class)
	return class.istype and class.istype or type(class);
end

function clamp(n, min, max)
	if( n < min ) then
		return min;
	end
	return n > max and max or n;
end
 
function printTable(tbl, t, mt, nt)
	if( not nt ) then
		print("Table:");
	end
	local Tabs = t or 1;
	local tbs = "\t";
	if( Tabs > 1 ) then
		for i = 1, Tabs do
			tbs = tbs .. "\t";
		end
	end
	if(type(tbl) == "table") then
		for k,v in pairs(tbl) do
			if(type(v) == "table" and mt) then
				print(tbs..k..":");
				printTable(v, Tabs+1, true, true);
			else
				print(tbs..k.." = "..tostring(v));
			end
		end
	else
		print(tbs..tostring(tbl))
	end
end

function fileEnumerateRecursive(dir, tree)
	local info = {}
	local lfs = love.filesystem;
	local files = lfs.getDirectoryItems(dir);
	local fileTree = tree or {};
	local file = "";
	for k,v in pairs(files) do
		file = dir.."/"..v;
		lfs.getInfo(file, info);
		if( info.type == "file" ) then
			table.insert(fileTree, file);
		elseif( info.type == "directory" ) then
			fileTree = fileEnumerateRecursive(file, fileTree);
		end
	end
	return fileTree;
end

require "json";
require "class";
require "timer";
require "balls";

require "class.state";
require "class.statemanager";
require "class.ball";
require "class.cannon";
require "class.animation";
require "class.player";
require "class.magnet";
require "class.balloon";

require "animations";
require "ui";

require "ui.base";
require "ui.main_board";
require "ui.string";
require "ui.button";
require "ui.container";
require "ui.image";
require "ui.label";

require "physics_callbacks";

SLING.GameState = new "CStateManager";
SLING.Player = new "CPlayer";

SLING.Splash = require "states.splash";
SLING.Menu = require "states.menu";
SLING.Game = require "states.game";
SLING.Editor = require "states.editor";

function love.loadpostdraw()

	local ssx, ssy, ssw, ssh = love.window.getSafeArea();

	SLING.Screen = {
		Width = ssw,
		Height = ssh,
		PixelScale = love.window.getDPIScale(),
		SafeArea = { x = ssx, y = ssy, w = ssw, h = ssh },
		Scale = { x = ssw/800, y = ssh/480 }

	}
	SLING.Screen.ScaleWidth, SLING.Screen.ScaleHeight = SLING.Screen.Width * SLING.Screen.PixelScale, SLING.Screen.Height * SLING.Screen.PixelScale;
	SLING.Font = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 14*SLING.Screen.Scale.y)
	SLING.GameState:Init();
	SLING.GameState:Push(SLING.Menu);
	SLING.GameState:Push(SLING.Splash, true);

	SLING.Player:Load();

	timer.Create(120, 0, "sling.player:save", SLING.Player.Save, SLING.Player);

	timer.Create(150, 0, "sling.ads.should_show_interstitial", function()
			SLING.ShowVideoAd = true;
		end);

	if( SLING.__COMPILE ) then
		if not SLING.Player.Data.Consent then
			--print("IN CONSENT");
			love.ads.changeEUConsent();
			SLING.Player.Data.Consent = true;
		end
	end


end


function love.load( arg )

end

local cap = 0;
local mT = love.timer.getTime
local capTime = 0;
function love.update( dt )

	SLING.__FPS = love.timer.getFPS();
	capTime = capTime + 1/60 -- TODO TIE THIS INTO USER SETTINGS

	SLING.GameState:Call("Think", dt);
	
	timer.Update();

	ui.Update(dt);

	cap = mT();
	if( capTime <= cap ) then
		capTime = cap;
		return;
	end
	love.timer.sleep(capTime - cap);

end

local LOAD_ONCE = false;
local LOAD_COUNT = 101;
function love.draw( )
	
	if( LOAD_COUNT > 0 ) then
		LOAD_COUNT = LOAD_COUNT - 1;
	end

	if not LOAD_ONCE and LOAD_COUNT == 0 then -- getSafeArea seems to be wrong until the first draw call... which is just found out has to be 100 frames later or it has a chance to still be wrong!
												-- More likely that I'm wrong about how to use this and this is my fault.. but I'm not willing to admit it right now.
		love.loadpostdraw();
		LOAD_ONCE = true;
	end

	if( LOAD_ONCE ) then

		SLING.GameState:Call("Draw");
		ui.Draw();

		SLING.GameState:Call("PostDraw");

	end


end

function love.touchmoved( id, x, y, dx, dy, pressure )

	SLING.GameState:Call("TouchMoved", id, x, y, dx, dy, pressure);

end

function love.mousepressed( x, y, button, istouch, presses )

	ui.Pressed(x, y, button, istouch, presses );

	if not( ui.Override.Press ) then
		SLING.GameState:Call("MousePressed", x, y, button, istouch, presses);
	end

end

function love.mousereleased(x, y, button, istouch, presses)

	ui.Released(x, y, button, istouch, presses)

	if not( ui.Override.Press ) then
		SLING.GameState:Call("MouseReleased", x, y, button, istouch, presses)
	end

end

function love.touchreleased( id, x, y, dx, dy, pressure )

	SLING.GameState:Call("TouchReleased", id, x, y, dx, dy, pressure);

end

function love.keypressed(k, s, i)

	SLING.GameState:Call("KeyPressed", k, s, i);

end

function love.visible( visible )
end

function love.lowmemory( )

	SLING.GameState:Call("LowMemory");

end

function love.quit()
	SLING.Player:Save();
end


