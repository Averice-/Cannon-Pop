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

	self.Scale = { x = SLING.Screen.Scale.x, y = SLING.Screen.Scale.y };

	self.Alpha = 1;

	self.Size = { w = 0, h = 0 };
	self.Color = { 1, 1, 1, 1 };
	self.Rotation = 0;

end

function PANEL:Think(dt)
end

function PANEL:SetImage(img)
	self.Image = img;
end

function PANEL:Draw()
	love.graphics.setColor(self.Color);
	love.graphics.draw(self.Image, self.Pos.x, self.Pos.y, self.Rotation, (self.Size.w/self.Image:getWidth()), (self.Size.h/self.Image:getHeight()));
end

function PANEL:OnPress()
end

ui.Register("Image", PANEL);

