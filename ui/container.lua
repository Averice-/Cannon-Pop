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


	self.Color = { 1, 1, 1, 0 };

	self.Size = { w = 0, h = 0 };
	self.Fill = false;
	self.Alpha = 1;

end

function PANEL:Think(dt)
end

function PANEL:Draw()
	love.graphics.setColor(self.Color[1], self.Color[2], self.Color[3], self.Alpha);
	love.graphics.rectangle(self.Fill and "fill" or "line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
end

function PANEL:OnPress()
end

ui.Register("Container", PANEL);

