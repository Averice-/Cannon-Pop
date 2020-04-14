--[[
	Sling Hoops
]]--

local PANEL = {}

function PANEL:Init()
	self.Pos = { x = 0, y = 0 };
	self.RealPos = { x = 0, y = 0 };
	self.Size = { w = 0, h = 0 };
	self.Visible = false;
	self.Children = {};
	self.Scale = 1;
end

function PANEL:SetPos(x, y)

	if( self.Parent ) then
		self.Pos = { x = self.Parent.Pos.x + x, y = self.Parent.Pos.y + y };
		self.RealPos = { x = x, y = y };
	else
		self.Pos = { x = x, y = y };
		self.RealPos = { x = x, y = y };
	end
	for i = 1, #self.Children do
		if( self.Children[i] ) then
			self.Children[i]:SetPos(self.Children[i].RealPos.x, self.Children[i].RealPos.y);
		end
	end

end

function PANEL:SetSize(w, h)
	self.Size = { w = w, h = h };
end

function PANEL:SetParent(p)
	self.Parent = p;
	table.insert(p.Children, self);
end

function PANEL:RemoveChild(p)
	for i = 1, #self.Children do
		if( self.Children[i] == p ) then
			table.remove(self.Children, i);
		end
	end
end

function PANEL:GetPos()
	return self.Pos.x, self.Pos.y;
end

function PANEL:GetSize()
	return self.Size.w, self.Size.h;
end

function PANEL:Think(dt)
end

function PANEL:_Think(dt)
	for i = 1, #self.Children do
		if( self.Children[i].Visible ) then
			self.Children[i]:Think(dt)
			self.Children[i]:_Think(dt)
		end
	end
end

function PANEL:Draw()
end

function PANEL:GetTextSizeInPixels(size)
	local text = love.graphics.newImage("textures/ui/Font/Brown/a.png");
	local scalex = SLING.Screen.Width/800;
	local scaley = SLING.Screen.Height/480;
	local x = (size / text:getWidth())*scalex;
	local y = (size / text:getHeight())*scaley;
	return x, y;
end


function PANEL:_Draw()
	for i = 1, #self.Children do
		if( self.Children[i].Visible ) then
			self.Children[i]:Draw();
			self.Children[i]:_Draw();
		end
	end
end

function PANEL:IsInside(x, y)
	return x > self.Pos.x and x < self.Pos.x + self.Size.w and y > self.Pos.y and y < self.Pos.y+self.Size.h;
end

function PANEL:GetInsidePanelRecurring(x, y)
	local ret = self;
	if( self.Children[1] ) then
		for i = 1, #self.Children do
			if( self.Children[i]:IsInside(x, y) and self.Children[i].Visible ) then
				ret = self.Children[i]:GetInsidePanelRecurring(x, y);
			end
		end
	end
	return ret;
end

function PANEL:OnPress()
end

function PANEL:OnRelease()
end

function PANEL:OnReleaseNoFunction()
end

ui.Register("Base", PANEL);

