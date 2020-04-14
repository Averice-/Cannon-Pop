--[[
	Sling Hoops
]]--

local PANEL = {}

function PANEL:Init()
	--ScrW, ScrH = SLING.windowWidth, SLING.windowHeight;

	self.Pos = { x = 0, y = 0 };
	self.Size = { w = 0, h = 0 };
	self.Visible = false;
	self.Children = {};

	local scalex = SLING.Screen.Width/800;
	local scaley = SLING.Screen.Height/480;
	self.Scale = { x = 0.5*scalex, y = 0.5*scaley };


	self.Image = love.graphics.newImage("textures/ui/mainboard_mm.png");
	self.AnimFloatDist = 10;
	self.AnimDir = -1
	self.AnimCurFloat = 0;

	self.Alpha = 1;

	self.Size = { w = self.Image:getWidth() * self.Scale.x, h = self.Image:getHeight() * self.Scale.y };

end

local SlowDown = 0;
local SlowIt = 5;
function PANEL:Think(dt)
	if( SlowDown == SlowIt ) then
		if( self.AnimCurFloat < self.AnimFloatDist and self.AnimDir == -1) then
			self:SetPos(self.Pos.x, self.Pos.y - 1);
			self.AnimCurFloat = self.AnimCurFloat+1;
			if( self.AnimCurFloat == self.AnimFloatDist ) then
				self.AnimDir = 1;
			end
		elseif( self.AnimCurFloat > 0 and self.AnimDir == 1) then
			self:SetPos(self.Pos.x, self.Pos.y + 1);
			self.AnimCurFloat = self.AnimCurFloat - 1;
			if( self.AnimCurFloat == 0 ) then
				self.AnimDir = -1;
			end
		end
		SlowDown = 0;
	end
	SlowDown = SlowDown+1
end

function PANEL:Draw()

	love.graphics.setColor(1, 1, 1, self.Alpha);
	love.graphics.draw(self.Image, self.Pos.x, self.Pos.y, 0, self.Scale.x, self.Scale.y);

end

function PANEL:OnPress()
end

ui.Register("MainBoard", PANEL);

