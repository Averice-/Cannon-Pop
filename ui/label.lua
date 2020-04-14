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

	self.Text = "";
	self.Font = SLING.Font;
	self.Alpha = 1;

	self.Size = { w = 0, h = 0 };
	self.Color = { 1, 1, 1, 1 };
	self.SecondColor = { 1, 1, 1, 1};
	self.AddSecondColor = false;
	self.Rotation = 0;

end

function PANEL:Think(dt)
end

function PANEL:SetText(t)
	self.Text = t or "";
end

function PANEL:Center() -- After setpos please. and tex.
	local w, h = self.Font:getWidth(self.Text), self.Font:getHeight(self.Text);
	self.RealPos.x = self.RealPos.x - w/2;
	self.RealPos.y = self.RealPos.y - h/2;

end

function PANEL:Draw()

	love.graphics.setFont(self.Font);
	if( self.AddSecondColor ) then
		love.graphics.setColor(self.SecondColor)
		love.graphics.print(self.Text, self.Pos.x - 2, self.Pos.y - 2, self.Rotation);
	end
	love.graphics.setColor(self.Color);
	love.graphics.print(self.Text, self.Pos.x, self.Pos.y, self.Rotation);

end

function PANEL:OnPress()
end

ui.Register("Label", PANEL);

