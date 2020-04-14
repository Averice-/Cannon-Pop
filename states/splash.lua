--[[ 
	Sling Hoops
]]--

local SplashScreen = new "CState";

function SplashScreen:Init()
	self.Image = love.graphics.newImage("textures/shard.png");
	self.Background = love.graphics.newImage("textures/splash-bg.jpg");
	self.Alpha = 0;
	self.AlphaTime = 100;
	self.StartTime = 30;
	self.Full = false;
end

function SplashScreen:PostInit()
end

function SplashScreen:Think(dt)
	if( self.Full ) then
		self.Alpha = clamp(self.Alpha - 3, 0, 255);
		if( self.Alpha == 0 ) then
			self.AlphaTime = self.AlphaTime - 1;
			if( self.AlphaTime <= 0 ) then
				SLING.GameState:Pop();
			end
		end
	else			
		if( self.StartTime <= 0 ) then
			self.Alpha = clamp(self.Alpha + 3, 0, 255);
			if( self.Alpha == 255 ) then
				self.AlphaTime = self.AlphaTime - 1;
				if( self.AlphaTime <= 0 ) then
					self.Full = true;
					self.AlphaTime = 50;
				end
			end
		end
	end
	self.StartTime = clamp(self.StartTime-1, 0, 30);

end

function SplashScreen:KeyPressed(key, uni)
	if( key == "escape" ) then
		SLING.GameState:Pop();
	end
end

local splWide, splHeight = 0, 0;
function SplashScreen:Draw()
	local ScrW, ScrH = love.graphics.getDimensions()

	love.graphics.setColor(0, 0, 0, 1);
	love.graphics.rectangle("fill", 0, 0, ScrW, ScrH);
		
	love.graphics.setColor(1, 1, 1, self.Alpha/255);
	love.graphics.draw(self.Background, (ScrW/2) - (self.Background:getWidth()/2), (ScrH/2) - (self.Background:getHeight()/2));
	love.graphics.draw(self.Image, (ScrW/2) - (self.Image:getWidth()/2), (ScrH/2) - (self.Image:getHeight()/2));
	
end

function SplashScreen:Shutdown()
	self.Image = nil;
	self.Background = nil;
end

return SplashScreen;


