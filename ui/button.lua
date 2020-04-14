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

	self.Text = {};
	self.TextColor = "Brown";
	self.TextSize = 14;
	self.TextSpacing = "2";

	self.Alpha = 1;

	self.Image = {
		Up = love.graphics.newImage("textures/ui/button_up.png"),
		Down = love.graphics.newImage("textures/ui/button_down.png")
	}

	self.IsPressed = false;

	self.Sound = love.audio.newSource("sounds/button_press.wav", "static");


end

function PANEL:SetButtonImage(img)

	local scalex = SLING.Screen.Scale.x;
	local scaley = SLING.Screen.Scale.y;
	
	self.Image.Scale = {
		scalex = (self.Size.w / self.Image.Up:getWidth()),-- * scalex,
		scaley = (self.Size.h / self.Image.Up:getHeight())-- * scaley
	}
	if( type(img) == "string" or type(img) == "number" ) then
		img = tostring(img)
		local button_table = {}
		button_table.Type = "string";
		button_table.Image = ui.CreatePanel("String", self);
	--	local px, py = self:GetTextSizeInPixels(button_table.Image.TextSize);
	--	local text_scale = ((self.Image.Up:getHeight() * self.Image.Scale.scaley) / button_table.Image.TextSize) -- This Scale is wrong, Fix it.

	--	button_table.Image.TextSize = math.floor(button_table.Image.TextSize * text_scale);
		button_table.Image.TextSize = self.TextSize;
		button_table.Image:SetText(img);
		local ypos = button_table.Image.Text.Characters[img:sub(1, 1)]:getHeight() * button_table.Image.Text.Positions[1].scaley

		button_table.Image:SetPos( (self.Image.Up:getWidth() * self.Image.Scale.scalex)/2,	(self.Image.Up:getHeight() * self.Image.Scale.scaley)/2 - (ypos/2));

		button_table.Image.OnPress = function(s)
			self:OnPress()
		end

		button_table.Image.OnRelease = function(s)
			self:OnRelease()
		end

		self.Info = button_table;
		self.Info.Image.Visible = true;

	elseif( type(img) == "userdata" ) then

		local button_table = {}
		button_table.Type = "Image";
		button_table.Image = img;
		button_table.Scale = {
			scalex = (self.Size.w / img:getWidth()) * scalex,
			scaley = (self.Size.h / img:getHeight()) * scaley
		}

		self.Size.w = self.Size.w*scalex;
		self.Size.h = self.Size.h*scaley;


		self.Info = button_table

	end

end

function PANEL:Think(dt)
end

function PANEL:Draw()

	if( self.Info and self.Info.Type == "Image" ) then
		local sx, sy = self.Info.Scale.scalex, self.Info.Scale.scaley;
		if( self.IsPressed ) then
			sx, sy = sx/1.2, sy/1.2;
		end
		love.graphics.setColor(1,1,1,self.Alpha);
		love.graphics.draw(self.Info.Image, self.Pos.x, self.Pos.y, 0, sx, sy);

	end

	if( self.Info and self.Info.Type == "string" ) then
		love.graphics.setColor(1,1,1,self.Alpha)

		if( self.IsPressed ) then
			love.graphics.draw(self.Image.Down, self.Pos.x, self.Pos.y, 0, self.Image.Scale.scalex, self.Image.Scale.scaley);
		else
			love.graphics.draw(self.Image.Up, self.Pos.x, self.Pos.y, 0, self.Image.Scale.scalex, self.Image.Scale.scaley);
		end

	end

end

function PANEL:OnPress()
	self.IsPressed = true;
end

function PANEL:OnRelease()
	self.IsPressed = false;
	self.Sound:play();
end

function PANEL:OnReleaseNoFunction()
	self.IsPressed = false;
end

ui.Register("Button", PANEL);

