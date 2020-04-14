--[[ 
	Sling Hoops
]]--

local EDITOR = new "CState";

function EDITOR:Init()

	self.Level = 1;
	self.Fired = false;
	self.Started = false;
	self.Obstacles = {};

	self.GridColor = { .3, .3, .3, .3 };

	self.Scale = {
		x = SLING.Screen.Width/800,
		y = SLING.Screen.Height/480
	}

	self.Images = {}

	self.Rotation = 0;

	self.GridSize = { x = 32 * self.Scale.x, y = 32 * self.Scale.y };

	self.Tool = false;

	love.physics.setMeter(SLING.Settings.Meter);
	SLING.World = love.physics.newWorld(0, 9.81*64, true);
	
	self.Obstacles = {}
	self.Cannon = new "CCannon";

	self.DrawCannon = new "CCannon";
	self.DrawCannon.Alpha = .4;

	self.SquareButton = ui.CreatePanel("Button");
	self.SquareButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.SquareButton.TextSize = 4;
	self.SquareButton:SetButtonImage("square");
	self.SquareButton:SetPos(20*self.Scale.x, 20*self.Scale.y);
	self.SquareButton.Visible = true;
	local oldPress = self.SquareButton.OnPress
	self.SquareButton.OnPress = function()
		self.Tool = "square";
		oldPress(self.SquareButton)
		self.Rotation = 0;
	end

	self.TriangleButton = ui.CreatePanel("Button");
	self.TriangleButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.TriangleButton.TextSize = 4;
	self.TriangleButton:SetButtonImage("triangle");
	self.TriangleButton:SetPos(20*self.Scale.x, 35*self.Scale.y);
	self.TriangleButton.Visible = true;
	local oldPress = self.TriangleButton.OnPress
	self.TriangleButton.OnPress = function()
		self.Tool = "triangle";
		oldPress(self.TriangleButton)
		self.Rotation = 0;
	end

	self.CannonButton = ui.CreatePanel("Button");
	self.CannonButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.CannonButton.TextSize = 4;
	self.CannonButton:SetButtonImage("cannon");
	self.CannonButton:SetPos(20*self.Scale.x, 50*self.Scale.y);
	self.CannonButton.Visible = true;
	local oldPress = self.CannonButton.OnPress
	self.CannonButton.OnPress = function()
		self.Tool = "cannon";
		oldPress(self.CannonButton);
		self.Rotation = 0;
	end
	
	self.BackgroundButton = ui.CreatePanel("Button");
	self.BackgroundButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.BackgroundButton.TextSize = 4;
	self.BackgroundButton:SetButtonImage("background");
	self.BackgroundButton:SetPos(20*self.Scale.x, 65*self.Scale.y);
	self.BackgroundButton.Visible = true;
	local oldPress = self.BackgroundButton.OnPress
	self.BackgroundButton.OnPress = function()
		oldPress(self.BackgroundButton);
		self.Tool = "background";
	end

	self.BlockButton = ui.CreatePanel("Button");
	self.BlockButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.BlockButton.TextSize = 4;
	self.BlockButton:SetButtonImage("bock type");
	self.BlockButton:SetPos(20*self.Scale.x, 80*self.Scale.y);
	self.BlockButton.Visible = true;
	local oldPress = self.BlockButton.OnPress
	self.BlockButton.OnPress = function()
		oldPress(self.BlockButton);
		self.Tool = "blocktype";
	end

	self.AnimButton = ui.CreatePanel("Button");
	self.AnimButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.AnimButton.TextSize = 4;
	self.AnimButton:SetButtonImage("animation");
	self.AnimButton:SetPos(20*self.Scale.x, 95*self.Scale.y);
	self.AnimButton.Visible = true;
	local oldPress = self.AnimButton.OnPress
	self.AnimButton.OnPress = function()
		oldPress(self.AnimButton);
		self.Tool = "animtype";
	end

	self.SaveButton = ui.CreatePanel("Button");
	self.SaveButton:SetSize(50*self.Scale.x, 10*self.Scale.y);
	self.SaveButton.TextSize = 4;
	self.SaveButton:SetButtonImage("save");
	self.SaveButton:SetPos(20*self.Scale.x, 110*self.Scale.y);
	self.SaveButton.Visible = true;
	local oldPress = self.SaveButton.OnPress
	self.SaveButton.OnPress = function()
		oldPress(self.SaveButton);
		self:SaveLevel();
	end

	self.BgImg = {
		spaceship = "textures/backgrounds/spaceship.png",
		forest = "textures/backgrounds/forest.jpg",
		mountain = "textures/backgrounds/mountain.jpg",
		swamp = "textures/backgrounds/swamp.jpg",
		medi = "textures/backgrounds/medi.jpg"
	}
	self.ImgTypes = {
		"spaceship",
		"forest",
		"forest2",
		"mountain",
		"mountain2",
		"medi",
		"medi2",
		"swamp",
		"swamp2",
		"castle",
		"castle2",
		"green",
		"green1",
		"green2",
		"ice",
		"rock",
		"rock2"
	}

	self.BackgroundImages = {}
	self.BlockTypeButtons = {}

	self.TextureButtons = {}
	self.AnimButtons = {}

	local vnum = 1;
	local ynum = 1;
	local cnt = 0;
	for k, v in pairs(ANIMATION) do
		local ab = ui.CreatePanel("Button");
		ab:SetSize(50*self.Scale.x, 10*self.Scale.y);
		ab.TextSize = 4;
		ab:SetButtonImage(v.Name);
		ab:SetPos((20*self.Scale.x)*ynum + (50*self.Scale.x) * ynum, (vnum*15)*self.Scale.y);
		ab.Visible = false;
		local oldPress = ab.OnPress
		ab.OnPress = function()
			self.AnimPicked = v;
			self.AnimFirstImage = love.graphics.newImage(v.Images[1]);
		end
		table.insert(self.AnimButtons, ab);
		vnum = vnum + 1;
		cnt = cnt+1;
		if( cnt == 20 ) then
			cnt = 0;
			vnum = 1;
			ynum = ynum+1;
		end
	end

	for i = 1, #self.ImgTypes do
		local it = ui.CreatePanel("Button");
		it:SetSize(50*self.Scale.x, 10*self.Scale.y);
		it.TextSize = 4;
		it:SetButtonImage(self.ImgTypes[i]);
		it:SetPos(20*self.Scale.x, (i*15)*self.Scale.y);
		it.Visible = false;
		local oldPress = it.OnPress;
		it.OnPress = function()
			oldPress(it);
			for i = 1, #self.BlockTypeButtons do
				self.BlockTypeButtons[i].Visible = false;
			end
			self.Tool = "blockpick";
			self:CreateBlockButtons(self.ImgTypes[i]);
			-- create block buttons and draw in lctrl if tool is blockpick.
			-- make sure blocktypebuttons get hidden
		end
		table.insert(self.BlockTypeButtons, it);
	end


	local cnum = 1;
	for k, v in pairs(self.BgImg) do
		local bg = ui.CreatePanel("Button");
		bg:SetSize(50*self.Scale.x, 10*self.Scale.y);
		bg.TextSize = 4;
		bg:SetButtonImage(k);
		bg:SetPos(20*self.Scale.x, (cnum*15)*self.Scale.y);
		bg.Visible = false;
		local oldPress = bg.OnPress;
		bg.OnPress = function()
			oldPress(bg);
			self.Background = {
				Image = love.graphics.newImage(v)
			}
			self.Background.Scale = {
				x = (SLING.Screen.Width/self.Background.Image:getWidth()),
				y = (SLING.Screen.Height/self.Background.Image:getHeight())
			}
			local obstacle = {
				Type = "Background",
				Image = k
			}
			table.insert(self.Obstacles, obstacle);
		end
		cnum = cnum + 1;
		table.insert(self.BackgroundImages, bg);
	end


end

function EDITOR:CreateBlockButtons(type)
	files = fileEnumerateRecursive("textures/platforms/"..type);
	local buttons = {}
	--local yPos = 10*self.Scale.y;
	local cX, cY = 0, 0;
	for i = 1, #files do
		--local xPos = 10*self.Scale.x;

		--xPos = i % 2 == 0 and xPos or (xPos*2)+25*self.Scale.x;
		--yPos = i % 2 == 0 and yPos-25*self.Scale.y or yPos;

		local image = love.graphics.newImage(files[i]);
		buttons[i] = ui.CreatePanel("Button");
		buttons[i]:SetSize(25, 25);
		buttons[i]:SetButtonImage(image);

		buttons[i]:SetPos(5+((25*SLING.Screen.Scale.x)*cX)+(cX*10), 5+((25*SLING.Screen.Scale.y)*cY)+(cY*10));


		buttons[i].Visible = true;
		buttons[i].OnPress = function()
			self.BlockImage = {
				image = image,
				text = files[i]
			}
			self.BlockImage.Scale = {
				x = self.GridSize.x/self.BlockImage.image:getWidth(),
				y = self.GridSize.y/self.BlockImage.image:getHeight()
			}
		end
		--xPos = xPos + 10*self.Scale.x;
		--yPos = yPos + 25*self.Scale.y;
		cX = cX+1;
		if( cX == 5 ) then
			cX = 0;
			cY = cY + 1;
		end
	end
	for i = 1, #self.TextureButtons do
		if( self.TextureButtons[i] ) then
			ui.RemovePanel(self.TextureButtons, i);
		end
	end
	self.TextureButtons = buttons;


end





function EDITOR:PostInit()
end

function EDITOR:LoadLevel(n)
end



function EDITOR:Think(dt)
	

end

function EDITOR:GetMouseInGrid()
	local mouseX = math.floor(love.mouse.getX()/self.GridSize.x);
	local mouseY = math.floor(love.mouse.getY()/self.GridSize.y);
	return mouseX, mouseY;
end


function EDITOR:MousePressed(x, y, button, istouch, pressed)

	if( self.Tool == "square" ) then

		local obstacle = {
			Type = "Square",
			Color = {.5,.5,.9,1},
			Pos = { x = math.floor(x/self.GridSize.x), y = math.floor(y/self.GridSize.y)}
		}
		table.insert(self.Obstacles, obstacle);

	elseif( self.Tool == "triangle" ) then

		local obstacle = {
			Type = "Triangle",
			Rotation = self.Rotation,
			Color = {.5, .9, .5, 1},
			Pos = { x = math.floor(x/self.GridSize.x), y = math.floor(y/self.GridSize.y) }
		}
		table.insert(self.Obstacles, obstacle);

	elseif( self.Tool == "cannon" ) then

		local obstacle = {
			Type = "Cannon",
			Rotation = self.Rotation,
			Pos = { x = math.floor(x/self.GridSize.x), y = math.floor(y/self.GridSize.y) }
		}
		table.insert(self.Obstacles, obstacle);
		self.Cannon:SetPos(obstacle.Pos.x*self.GridSize.x, obstacle.Pos.y*self.GridSize.y);
		self.Cannon.Rotation = self.Rotation;


	elseif( self.Tool == "blockpick" ) then
		if( self.BlockImage ) then
			local obstacle = {
				Type = "Image",
				Rotation = self.Rotation,
				Pos = { x = math.floor(x/self.GridSize.x), y = math.floor(y/self.GridSize.y) },
				Image = self.BlockImage.text
			}
			if not self.Images[self.BlockImage.text] then
				self.Images[self.BlockImage.text] = love.graphics.newImage(self.BlockImage.text);
			end
			table.insert(self.Obstacles, obstacle);
		end

	elseif( self.Tool == "animtype" ) then

		local obstacle = {
			Type = "Animation",
			Rotation = self.Rotation,
			Pos = { x = math.floor(x/self.GridSize.x), y = math.floor(y/self.GridSize.y) },
			Animation = self.AnimPicked.Name
		}
		if not self.Images[self.AnimFirstImage] then
			self.Images[self.AnimPicked.Images[1]] = self.AnimFirstImage;
		end
		table.insert(self.Obstacles, obstacle);
	end


end

function EDITOR:KeyPressed(key, uni)
	if( key == "r" ) then
		self.Rotation = self.Rotation + 45;
		if( self.Rotation == 360 ) then
			self.Rotation = 0;
		end
	end

	if( key == "lalt" ) then
		self.SquareButton.Visible = not self.SquareButton.Visible;
		self.TriangleButton.Visible = not self.TriangleButton.Visible;
		self.CannonButton.Visible = not self.CannonButton.Visible;
		self.BackgroundButton.Visible = not self.BackgroundButton.Visible;
		self.BlockButton.Visible = not self.BlockButton.Visible;
		self.AnimButton.Visible = not self.AnimButton.Visible;
		self.SaveButton.Visible = not self.SaveButton.Visible;
	end

	if( key == "lctrl" ) then
		if( self.Tool == "background") then
			for i = 1, #self.BlockTypeButtons do
				self.BlockTypeButtons[i].Visible = false;
			end
			for i = 1, #self.TextureButtons do
				self.TextureButtons[i].Visible = false;
			end
			for i = 1, #self.BackgroundImages do
				self.BackgroundImages[i].Visible = not self.BackgroundImages[i].Visible;
			end
		elseif(self.Tool == "blocktype") then
			for i = 1, #self.BackgroundImages do
				self.BackgroundImages[i].Visible = false;
			end
			for i = 1, #self.TextureButtons do
				self.TextureButtons[i].Visible = false;
			end
			for i = 1, #self.BlockTypeButtons do
				self.BlockTypeButtons[i].Visible = not self.BlockTypeButtons[i].Visible;
			end
		elseif( self.Tool == "blockpick" ) then
			for i = 1, #self.TextureButtons do
				self.TextureButtons[i].Visible = not self.TextureButtons[i].Visible;
			end
		elseif( self.Tool == "animtype" ) then
			for i = 1, #self.AnimButtons do
				self.AnimButtons[i].Visible = not self.AnimButtons[i].Visible;
			end
		end
	end

	if( key == "z" ) then
		self:Undo()
	end

	--if( key == "escape" ) then
	--	SLING.GameState:Pop();
	--end
end

function EDITOR:DrawGrid()

	local gridX = math.floor(SLING.Screen.Width/self.GridSize.x);
	local gridY = math.floor(SLING.Screen.Height/self.GridSize.y);
	love.graphics.setColor(self.GridColor);
	for x = 1, gridX do
		love.graphics.line(self.GridSize.x*x, 0, self.GridSize.x*x, SLING.Screen.Height);
	end
	for y = 1, gridY do
		love.graphics.line(0, self.GridSize.y*y, SLING.Screen.Width, self.GridSize.y*y);
	end

end
function EDITOR:Draw() -- What a fucking draww call Am i right?

	if( self.Background ) then
		love.graphics.setColor(1, 1, 1, 1);
		love.graphics.draw(self.Background.Image, 0, 0, 0, self.Background.Scale.x, self.Background.Scale.y);
	end
	self:DrawGrid();

	local x, y = self:GetMouseInGrid();
	x, y = x * self.GridSize.x, y * self.GridSize.y;

	for i = 1, #self.Obstacles do

		local ob = self.Obstacles[i];
		local obx, oby = 0, 0;
		if not( ob.Type == "Background" ) then

			obx, oby = ob.Pos.x * self.GridSize.x, ob.Pos.y * self.GridSize.y

		end

		if( ob.Type == "Square" ) then

			love.graphics.setColor(ob.Color);
			love.graphics.rectangle("fill", obx, oby, self.GridSize.x, self.GridSize.y);

		elseif( ob.Type == "Triangle" ) then

			love.graphics.setColor(ob.Color);
			local t_points = {}
			if( ob.Rotation == 0 or ob.Rotation == 45 ) then

				t_points = { obx,	oby, obx, oby+self.GridSize.y, obx+self.GridSize.x, oby+self.GridSize.y }

			end
			if( ob.Rotation == 90 or ob.Rotation == 135) then

				t_points = { obx+self.GridSize.x,	oby, obx, oby+self.GridSize.y, obx, oby }

			elseif( ob.Rotation == 180 or ob.Rotation == 225) then

				t_points = { obx,	oby, obx+self.GridSize.x, oby, obx+self.GridSize.x, oby+self.GridSize.y }

			elseif( ob.Rotation == 270 or ob.Rotation == 315) then

				t_points = { obx+self.GridSize.x, oby, obx+self.GridSize.x, oby+self.GridSize.y, obx, oby+self.GridSize.y }

			end

			love.graphics.polygon("fill", t_points);

		elseif( ob.Type == "Image" ) then

			love.graphics.setColor(1, 1, 1, 1);
			love.graphics.draw(self.Images[ob.Image],  obx+self.GridSize.x/2, oby+self.GridSize.y/2, math.rad(ob.Rotation), self.GridSize.x/self.Images[ob.Image]:getWidth(), self.GridSize.y/self.Images[ob.Image]:getHeight(),
																						self.Images[ob.Image]:getWidth()/2, self.Images[ob.Image]:getHeight()/2);

		elseif( ob.Type == "Animation" ) then

			local aimg = self.Images[ANIMATION[ob.Animation].Images[1]];
			local anim = ANIMATION[ob.Animation];
			love.graphics.setColor(1, 1, 1, 1);
			if( anim.Circle ) then
				love.graphics.draw(aimg, obx+self.GridSize.x/2, oby+self.GridSize.y/2, math.rad(ob.Rotation), (anim.Radius*2/aimg:getWidth())*SLING.Screen.Scale.x, (anim.Radius*2/aimg:getHeight())*SLING.Screen.Scale.y, aimg:getWidth()/2, aimg:getHeight()/2);
			else
				love.graphics.draw(aimg, obx+self.GridSize.x/2, oby+self.GridSize.y/2, math.rad(ob.Rotation), anim.Scale*self.Scale.x, anim.Scale*self.Scale.y, aimg:getWidth()/2, aimg:getHeight()/2);
			end


		elseif( ob.Type == "Cannon" ) then
			if( self.Cannon.CannonPhysics ) then
				self.Cannon:Draw();
			end
		end

	end

	if( self.Tool == "square" ) then

		love.graphics.setColor(.5,0,0,.3);
		love.graphics.rectangle("fill", x, y, self.GridSize.x, self.GridSize.y);

	elseif( self.Tool == "triangle" ) then
		local t_points = {}
		if( self.Rotation == 0 or self.Rotation == 45 ) then

			t_points = { x,	y, x, y+self.GridSize.y, x+self.GridSize.x, y+self.GridSize.y }

		end
		if( self.Rotation == 90 or self.Rotation == 135) then

			t_points = { x+self.GridSize.x,	y, x, y+self.GridSize.y, x, y }

		elseif( self.Rotation == 180 or self.Rotation == 225 ) then

			t_points = { x,	y, x+self.GridSize.x, y, x+self.GridSize.x, y+self.GridSize.y }

		elseif( self.Rotation == 270 or self.Rotation == 315) then

			t_points = { x+self.GridSize.x, y, x+self.GridSize.x, y+self.GridSize.y, x, y+self.GridSize.y }

		end
		love.graphics.setColor(.5, 0, 0, .3);
		love.graphics.polygon("fill", t_points);
	
	elseif( self.Tool == "cannon" ) then

		self.DrawCannon.Rotation = self.Rotation;
		self.DrawCannon:SetPos( x, y );

		self.DrawCannon:Draw();

	elseif( self.Tool == "blockpick" ) then

		if( self.BlockImage ) then
			love.graphics.setColor(1, 1, 1, .5);
			love.graphics.draw(self.BlockImage.image, x+self.GridSize.x/2, y+self.GridSize.y/2, math.rad(self.Rotation), self.BlockImage.Scale.x, self.BlockImage.Scale.y,
																					self.BlockImage.image:getWidth()/2, self.BlockImage.image:getHeight()/2);
		end

	elseif( self.Tool == "animtype" ) then

		if( self.AnimPicked ) then
			love.graphics.setColor(1, 1, 1, .5);
			if( self.AnimPicked.Circle ) then
				love.graphics.draw(self.AnimFirstImage, x+self.GridSize.x/2, y+self.GridSize.y/2, math.rad(self.Rotation), (self.AnimPicked.Radius*2/self.AnimFirstImage:getWidth())*SLING.Screen.Scale.x, (self.AnimPicked.Radius*2/self.AnimFirstImage:getHeight())*SLING.Screen.Scale.y, self.AnimFirstImage:getWidth()/2, self.AnimFirstImage:getHeight()/2);
			else
				love.graphics.draw(self.AnimFirstImage, x+self.GridSize.x/2, y+self.GridSize.y/2, math.rad(self.Rotation), self.AnimPicked.Scale*self.Scale.x, self.AnimPicked.Scale*self.Scale.y, self.AnimFirstImage:getWidth()/2, self.AnimFirstImage:getHeight()/2);
			end
		end
	end

end

function EDITOR:SaveLevel()
	local Level = "level_"..math.random(1, 9999)..".txt";
	local data = json.encode(self.Obstacles);
	love.filesystem.write(Level, data);
end

function EDITOR:Undo()
	if( self.Obstacles and #self.Obstacles > 0 ) then
		self.Obstacles[#self.Obstacles] = nil;
	end
end

function EDITOR:Shutdown()

end

return EDITOR;


