--[[ 
	Sling Hoops
]]--

local GAME = new "CState";


function GAME:Init()

	self.Level = 1;
	self.Score = 0;
	self.Fired = false;
	self.Started = false;
	self.Obstacles = {}
	self.Bodies = {}
	self.Bounds = {}

	self.ScoreFont = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 40*SLING.Screen.Scale.y);
	self.Particles = {}

	self.Font = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 30*SLING.Screen.Scale.y);

	self.CoinAnimation = new "CAnimation";
	self.CoinAnimation:NewAnimation(ANIMATION.coin.Images, 0.8);
	self.CoinAnimation:SetPos(32*SLING.Screen.Scale.x, 32*SLING.Screen.Scale.y);
	self.CoinAnimation:SetScale(ANIMATION.coin.Scale * SLING.Screen.Scale.x, ANIMATION.coin.Scale * SLING.Screen.Scale.y);
	self.CoinAnimation:Loop();
	self.CoinAnimation:Play();

	self.cText = { 
		(self.CoinAnimation.Frames[1]:getWidth() * (ANIMATION.coin.Scale*SLING.Screen.Scale.x)) + (32*SLING.Screen.Scale.x)+ 10,
		((self.CoinAnimation.Frames[1]:getHeight() * (ANIMATION.coin.Scale*SLING.Screen.Scale.y))/2) + (32*SLING.Screen.Scale.y)-15*SLING.Screen.Scale.y,
		0
	}

	self.CheckPointSounds = {
		balloon_pop = {
			Inflate = love.audio.newSource("sounds/ballooninflate.wav", "static"),
			Pop = love.audio.newSource("sounds/balloonpop.wav", "static")
		}
	}
	self.ButtonSound = love.audio.newSource("sounds/button_hit.wav", "static");
	self.StarsSound = love.audio.newSource("sounds/stars.wav", "static");

	self.RestartLevelButton = ui.CreatePanel("Button");
	self.RestartLevelButton:SetSize(64, 64);
	self.RestartLevelButton:SetButtonImage(love.graphics.newImage("textures/ui/restart.png"));
	self.RestartLevelButton:SetPos(SLING.Screen.Width/2-(32*SLING.Screen.Scale.x), SLING.Screen.Height/2);
	self.RestartLevelButton.Visible = false;
	local oldrel = self.RestartLevelButton.OnRelease;
	self.RestartLevelButton.OnRelease = function()
		oldrel(self.RestartLevelButton);
		SLING.Player.Data.SelectedLevel = self.CurrentLevel;
		self:ForceNextLevel();
	end

	self.NextLevelButton = ui.CreatePanel("Button");
	self.NextLevelButton:SetSize(64, 64);
	self.NextLevelButton:SetButtonImage(love.graphics.newImage("textures/ui/forward1.png"));
	self.NextLevelButton:SetPos(SLING.Screen.Width/2+(64*SLING.Screen.Scale.x), SLING.Screen.Height/2);
	self.NextLevelButton.Visible = false;
	local oldrel = self.NextLevelButton.OnRelease
	self.NextLevelButton.OnRelease = function()
		oldrel(self.NextLevelButton);
		if( SLING.__COMPILE ) then
			if( SLING.ShowVideoAd and love.ads.isInterstitialLoaded() ) then
				SLING.ShowVideoAd = false;
				love.ads.showInterstitial()
				timer.Simple(60, love.ads.requestInterstitial, "ca-app-pub-3940256099942544/8691691433");
			else			
				self:ForceNextLevel();
			end
		else
			self:ForceNextLevel(); -- gotta debug bro.
		end
	end

	self.MainMenuButton = ui.CreatePanel("Button");
	self.MainMenuButton:SetSize(64, 64);
	self.MainMenuButton:SetButtonImage(love.graphics.newImage("textures/ui/back_to_menu.png"));
	self.MainMenuButton:SetPos(SLING.Screen.Width/2-(128*SLING.Screen.Scale.x), SLING.Screen.Height/2);
	self.MainMenuButton.Visible = false;
	local oldrel = self.MainMenuButton.OnRelease;
	self.MainMenuButton.OnRelease = function()
		oldrel(self.MainMenuButton);
		if( #SLING.GameState:GetAll() > 1 ) then
			SLING.GameState:Pop();
		end
	end

	local scorew = self.ScoreFont:getWidth("500");
	self.ScoreLabel = ui.CreatePanel("Label");
	self.ScoreLabel.Font = self.ScoreFont;
	self.ScoreLabel:SetText(1000);
	self.ScoreLabel:SetPos(SLING.Screen.Width/2-((scorew/2)), SLING.Screen.Height/2-(50*SLING.Screen.Scale.y));
	--self.ScoreLabel:Center();
	self.ScoreLabel.AddSecondColor = true;
	self.ScoreLabel.SecondColor = {230/255, 191/255, 0, 1}
	self.ScoreLabel.Color = {186/255, 134/255, 50/255, .7}


	self.LevelEnd = false;
	self.Loaded = false;
	self.StarsDrawn = false;

	self.Scale = {
		x = SLING.Screen.Scale.x,
		y = SLING.Screen.Scale.y
	}

	self.Bounces = 0;

	self.Images = {}

	self.ButtonCount = 0;
	self.ButtonPushes = 0;

	self.Animations = {}

	self.NoFire = false;
	self.LevelEnd = false;
	self.LevelEndNow = false;

	self.CannonBalls = {};


	self.GridSize = { x = 32 * self.Scale.x, y = 32 * self.Scale.y };


	love.physics.setMeter(SLING.Settings.Meter*SLING.Screen.Scale.x);
	SLING.World = love.physics.newWorld(0, 9.81*(64*SLING.Screen.Scale.x), true);

	SLING.World:setCallbacks(callbacks.BeginContact, nil, callbacks.PreSolve)

	self.Cannon = new "CCannon";

	self:CreateWorldBounds();

	self:LoadLevel("level"..SLING.Player.Data.SelectedLevel..".txt");
	self.CurrentLevel = SLING.Player.Data.SelectedLevel;

	self.Stars = new "CAnimation";
	self.Stars:NewAnimation(ANIMATION.stars.Images, ANIMATION.stars.Time);
	self.Stars:SetPos((SLING.Screen.Width/2), (SLING.Screen.Height/4));
	self.Stars:CenterOrigin();
	self.Stars:SetScale(ANIMATION.stars.Scale*self.Scale.x, ANIMATION.stars.Scale*self.Scale.y);
	self.Stars:Pulsate(0.3, 0.01, 4);
	self.Stars.OnFrameChange = function()
		self.StarsSound:stop();
		self.StarsSound:play();
	end

	SLING.Player.Data.BallsLeft = SLING.Player.Data.MaxBalls;

	self.BallsLeftRotation = 0;

	local Exit = ui.CreatePanel("Button");
	Exit:SetSize(32, 32);
	Exit:SetButtonImage(love.graphics.newImage("textures/ui/exit.png"));
	Exit:SetPos(SLING.Screen.Width-(64*SLING.Screen.Scale.x), 32*SLING.Screen.Scale.y);
	Exit.Visible = true;
	local oldres = Exit.OnRelease;
	Exit.OnRelease = function()
		oldres(Exit)
		if( #SLING.GameState:GetAll() > 1 ) then
			SLING.GameState:Pop();
		end
	end

	local Restart = ui.CreatePanel("Button");
	Restart:SetSize(32, 32);
	Restart:SetButtonImage(love.graphics.newImage("textures/ui/restart.png"));
	Restart:SetPos(SLING.Screen.Width-(64*SLING.Screen.Scale.x), 69*SLING.Screen.Scale.y);
	Restart.Visible = true;
	local oldrel = Restart.OnRelease;
	Restart.OnRelease = function()
		oldrel(Restart);
		timer.Remove("game:noballend", true); -- just incase people suck at this game.
		SLING.Player.Data.SelectedLevel = self.CurrentLevel;
		self:ForceNextLevel();
	end


	local ballsound = love.audio.newSource("sounds/button_press.wav", "static");
	self.ImgBalls = {}
	local i = 1;
	for k, v in pairs(SLING.Player.Data.Skins) do
		local Image = ui.CreatePanel("Image");
		Image:SetSize(32*SLING.Screen.Scale.x, 32*SLING.Screen.Scale.x);
		Image:SetPos(SLING.Screen.Width-((32*i+69)*SLING.Screen.Scale.x), 32*SLING.Screen.Scale.y);
		Image:SetImage(SLING.BallTypes[v].Image);
		Image.Visible = true;
		table.insert(self.ImgBalls, Image)
		Image.OnRelease = function()
			SLING.Player.Data.SelectedSkin = v;
			SLING.Game.Cannon.FakeBall.Body:destroy();
			SLING.Game.Cannon.FakeBall = new "CBall";
			SLING.Game.Cannon.FakeBall:Create(SLING.BallTypes[v].Radius, -100, -100);
			SLING.Game.Cannon.FakeBall.Body:setActive(false);
			SLING.Game.Cannon.FakeBall.Body:setMass(self.Cannon.FakeBall.DefaultMass*SLING.BallTypes[v].MassMultiplyer);
			if( SLING.Game.Cannon.Ball.Body ) then
				SLING.Game.Cannon.Ball:Delete();
			end
			ballsound:play();
		end
		i = i + 1;
	end



end

function GAME:PostInit()
end

function GAME:PortalActive(x, y, vx, vy)
	self.Portal = { x, y, vx, vy };
end

function GAME:CreateObstacleBody(ob, n)

	local newBody = {}
	local category16 = false;

	if( ob.Type == "Cannon" ) then
		self.Cannon:SetPos(ob.Pos.x*self.GridSize.x, ob.Pos.y*self.GridSize.y);
		table.insert(self.Bodies, {})
		return;
	end

	if( ob.Type == "Background" ) then
		self.Background = {
			Image = love.graphics.newImage("textures/backgrounds/"..ob.Image..".jpg")
		}
		self.Background.Scale = {
			x = (SLING.Screen.Width/self.Background.Image:getWidth()),
			y = (SLING.Screen.Height/self.Background.Image:getHeight())
		}
		table.insert(self.Bodies, {})
		return;
	end

	if( ob.Type == "Image" ) then
		if not self.Images[ob.Image] then
			self.Images[ob.Image] = love.graphics.newImage(ob.Image);
		end
		table.insert(self.Bodies, {});
		return;
	end

	if( ob.Type == "Animation" ) then

		local anim_lookup = ANIMATION[ob.Animation];
		local anim = new "CAnimation";

		anim:NewAnimation(anim_lookup.Images, anim_lookup.Time);
		anim:SetPos((ob.Pos.x*self.GridSize.x)+self.GridSize.x/2, (ob.Pos.y*self.GridSize.y)+self.GridSize.y/2);
		anim:CenterOrigin();
		anim:SetRotation(ob.Rotation)
		anim:SetScale(anim_lookup.Scale*self.Scale.x, anim_lookup.Scale*self.Scale.y);
		if( anim_lookup.PhysicsEnabled ) then
			anim:ApplyPhysics(SLING.World, anim_lookup.PhysScale, anim_lookup.PhysType, anim_lookup.Circle or false, anim_lookup.Radius or 0);
		end
		if( anim_lookup.Pulse ) then
			anim:Pulsate(0.1, 0.01, 4);
		end
		anim.Type = anim_lookup.Type;

		if( anim_lookup.Type == "Cball" ) then
			anim.Phys.Body:setMass(anim.Phys.Body:getMass()*2);
			table.insert(self.CannonBalls, anim);
		end
		if( anim_lookup.Type == "Magnet" ) then

			anim.Magnet = new "CMagnet";
			anim.Magnet:Create((ob.Pos.x*self.GridSize.x)+self.GridSize.x/2, (ob.Pos.y*self.GridSize.y)+self.GridSize.y/2, ob.Rotation)

		end

		if( anim_lookup.Type == "Balloon" ) then

			anim.Balloon = new "CBalloon";
			anim.Balloon:Create((ob.Pos.x*self.GridSize.x)+self.GridSize.x/2, (ob.Pos.y*self.GridSize.y)+self.GridSize.y/2, anim)

		end

		if( anim_lookup.Type == "PortalExit" ) then
			self.PortalExitPos = {
				x = (ob.Pos.x * self.GridSize.x) + self.GridSize.x,
				y = (ob.Pos.y * self.GridSize.y) + self.GridSize.y
			}
			self.PortalExitRot = ob.Rotation;
		end

		if( anim.Type == "Checkpoint" ) then

			self.Checkpoint = anim;
			self.CheckpointFrames = #anim.Frames;

			anim.OnEnd = function()
				self.Playing = false;
				self.NoFire = true;
				self.LevelEndNow = true;
				timer.Simple(1.5, function()

					timer.Remove("game:noballend", true); -- just incase people suck at this game.

					local fscore, stardiv = SLING.Player:ScoreCalculator(100, 1000*self.ButtonCount, self.ButtonCount);
					if not stardiv then stardiv = 0 end
					self.LevelEnd = true;
					self.FinalScore = fscore;
					self.Stars:Play(math.floor(3*stardiv)+1);
					local oldcng = self.Stars.OnFrameChange;
					self.ScoreLabel:SetText(self.FinalScore);
					self.Stars.OnFrameChange = function()
						oldcng(self.Stars);
						self.ScoreLabel:SetText(math.floor((self.FinalScore/#self.Stars.Frames)*self.Stars.CurrentFrame));
						--self.ScoreLabel:Center()
					end

					if( SLING.Player.Data.SelectedLevel + 1 <= SLING.MaxLevels ) then
						if( SLING.Player.Data.LevelReached < SLING.Player.Data.SelectedLevel + 1) then
							SLING.Player.Data.LevelReached = SLING.Player.Data.SelectedLevel + 1;
						end

						SLING.Player.Data.SelectedLevel = SLING.Player.Data.SelectedLevel + 1;
						self.NextLevelButton.Visible = true;
					end
					SLING.Player:GiveCoins(math.floor(self.FinalScore));
					self.ScoreLabel.Visible = true;
					self.RestartLevelButton.Visible = true;
					self.MainMenuButton.Visible = true;
					SLING.Player:Save()
					if( SLING.__COMPILE ) then
						love.ads.showBanner();
					end

				end);
			end

			if( anim_lookup.Name == "balloon_pop" ) then
				anim.OnFrameChange = function()
					if( anim.CurrentFrame == 7 ) then
						self.CheckPointSounds.balloon_pop.Pop:play();
					elseif( anim.CurrentFrame == 2 ) then
						self.CheckPointSounds.balloon_pop.Inflate:play();
					elseif( anim.CurrentFrame == 3 ) then
						self.CheckPointSounds.balloon_pop.Inflate:stop();
					elseif( anim.CurrentFrame == 4 ) then
						self.CheckPointSounds.balloon_pop.Inflate:play();
					elseif( anim.CurrentFrame == 6 ) then
						self.CheckPointSounds.balloon_pop.Inflate:stop();
					end
				end
			end

		end

		if( anim.Type == "MagnetButton" ) then

			self.MagnetOn = {}
			self.MagnetOn.Pushed = false;

			anim.OnEnd = function()
				self.MagnetOn.Pushed = not self.MagnetOn.Pushed;
				anim.Phys.Body:destroy();
				anim.Phys = nil;
			end
			category16 = true;


		end

		if( anim.Type == "Button" ) then

			self.ButtonCount = self.ButtonCount + 1;
			anim.Pressed = false;

			anim.OnEnd = function()
				self.ButtonPushes = self.ButtonPushes + 1;
				self:ButtonPushed()
			end

			anim.OnFrameChange = function()
				if( anim.CurrentFrame == 2 ) then
					self.ButtonSound:play();
				end
			end
			category16 = true;

		end
		self.Animations[n] = anim;
		table.insert(self.Bodies, {});
		return;
	end


	local obx, oby = ob.Pos.x*self.GridSize.x, ob.Pos.y*self.GridSize.y;
	newBody.Body = love.physics.newBody(SLING.World, obx, oby, "static");
	obx, oby = 0, 0
	if( ob.Type == "Triangle" ) then

		if( ob.Rotation == 0 or ob.Rotation == 45 ) then
			newBody.Shape = love.physics.newPolygonShape(obx,	oby, obx, oby+self.GridSize.y, obx+self.GridSize.x, oby+self.GridSize.y);

		elseif( ob.Rotation == 90 or ob.Rotation == 135 ) then
			newBody.Shape = love.physics.newPolygonShape(obx+self.GridSize.x,	oby, obx, oby+self.GridSize.y, obx, oby);

		elseif( ob.Rotation == 180 or ob.Rotation == 225) then
			newBody.Shape = love.physics.newPolygonShape(obx,	oby, obx+self.GridSize.x, oby, obx+self.GridSize.x, oby+self.GridSize.y);

		elseif( ob.Rotation == 270 or ob.Rotation == 315) then
			newBody.Shape = love.physics.newPolygonShape(obx+self.GridSize.x, oby, obx+self.GridSize.x, oby+self.GridSize.y, obx, oby+self.GridSize.y);

		end

	elseif( ob.Type == "Square" ) then

		newBody.Shape = love.physics.newPolygonShape(obx, oby, obx+self.GridSize.x, oby, obx+self.GridSize.x, oby+self.GridSize.y, obx, oby+self.GridSize.y);

	end
	local Res = SLING.Settings.WorldRes
	newBody.Fixture = love.physics.newFixture(newBody.Body, newBody.Shape, 1);
	newBody.Fixture:setRestitution(Res);
	newBody.Body:setActive(true);
	if( ob.Type == "Square" or ob.Type == "Triangle" ) then
		newBody.Fixture:setCategory(16);
	end
	if( category16 ) then
		newBody.Fixture:setMask(16);
	end

	table.insert(self.Bodies, newBody);
end

function GAME:ButtonPushed()
	if( self.ButtonPushes == self.ButtonCount ) then
		self.Checkpoint:Play();
		return;
	end
	self.Checkpoint:Play(math.floor((self.CheckpointFrames/self.ButtonCount))*self.ButtonPushes);
end


function GAME:CreateWorldBounds()
	local res = SLING.Settings.WorldRes
	local LeftWall = {}
	LeftWall.Body = love.physics.newBody(SLING.World, -128, -128, "static");
	LeftWall.Shape = love.physics.newPolygonShape(0, 0, 0, SLING.Screen.Height+256, 32, SLING.Screen.Height+256, 32, 0);
	LeftWall.Fixture = love.physics.newFixture(LeftWall.Body, LeftWall.Shape, 1);
	LeftWall.Fixture:setRestitution(res);
	LeftWall.Fixture:setUserData("OUTOFBOUNDS");
	self.Bounds.Left = LeftWall;

	local RightWall = {}
	RightWall.Body = love.physics.newBody(SLING.World, SLING.Screen.Width+128, -128, "static");
	RightWall.Shape = love.physics.newPolygonShape(0, 0, 0, SLING.Screen.Height+256, 32, SLING.Screen.Height+256, 32, 0);
	RightWall.Fixture = love.physics.newFixture(RightWall.Body, RightWall.Shape, 1);
	RightWall.Fixture:setRestitution(res);
	RightWall.Fixture:setUserData("OUTOFBOUNDS");
	self.Bounds.Right = RightWall;

	local TopWall = {}
	TopWall.Body = love.physics.newBody(SLING.World, -128, -128, "static");
	TopWall.Shape = love.physics.newPolygonShape(0, 0, 0, 32, SLING.Screen.Width+256, 32, SLING.Screen.Width+256, 0);
	TopWall.Fixture = love.physics.newFixture(TopWall.Body, TopWall.Shape, 1);
	TopWall.Fixture:setRestitution(res);
	TopWall.Fixture:setUserData("OUTOFBOUNDS");
	self.Bounds.Top = TopWall;

	local BottomWall = {}
	BottomWall.Body = love.physics.newBody(SLING.World, 128, SLING.Screen.Height+128, "static");
	BottomWall.Shape = love.physics.newPolygonShape(0, 0, 0, 32, SLING.Screen.Width+256, 32, SLING.Screen.Width+256, 0);
	BottomWall.Fixture = love.physics.newFixture(BottomWall.Body, BottomWall.Shape, 1);
	BottomWall.Fixture:setRestitution(res);
	BottomWall.Fixture:setUserData("OUTOFBOUNDS");
	self.Bounds.Bottom = BottomWall;
end

function GAME:LoadLevel(n)

	local level = love.filesystem.read("levels/"..n);
	self.Obstacles = json.decode(level);

	for i = 1, #self.Obstacles do
		self:CreateObstacleBody(self.Obstacles[i], i);
	end

end


function math.distance(x1, y1, x2, y2)

  local dx = (x1 - x2)
  local dy = (y1 - y2)

  return math.sqrt ( dx * dx + dy * dy );

end

function GAME:Think(dt)

	if( self.Loaded ) then

		if( self.Portal ) then

			self.Cannon.Ball.Body:setPosition(self.Portal[1], self.Portal[2]);
			self.Cannon.Ball.Body:setLinearVelocity(0, 0);
			self.Cannon.Ball.Body:setLinearVelocity(self.Portal[3]*1.5, self.Portal[4]*1.5);
			--self.Cannon.Ball.Body:applyForce(self.Portal[3], self.Portal[4]);

			self.Portal = nil;

		end

		self.BallsLeftRotation = self.BallsLeftRotation + dt;
		if( self.BallsLeftRotation >= 360 ) then
			self.BallsLeftRotation = 0;
		end

		for k, v in pairs(self.Particles) do
			v:update(dt);
		end

		if( self.Cannon ) then

			local bX, bY = self.Cannon.Pos.x, self.Cannon.Pos.y;
			local mX, mY = love.mouse.getPosition();

			if( mX <= bX ) then -- Please stand behind the cannon sir.

				local dist = math.distance(mX, mY, bX, bY);
				local angle = math.atan2(bY-mY, bX-mX);
				--local ForceX, ForceY = math.cos(angle) * (s * dist or 200 * dist), math.sin(angle) * (s * dist or 200 * dist);

				self.Cannon.Rotation = clamp(angle, -1.1, 1.1);
				self.Cannon.CannonPhysics.Body:setAngle(self.Cannon.Rotation);

			end

			self.Cannon:Think(dt);

		end

		for k, v in pairs(self.Animations) do
			v:Think(dt);
		end

		SLING.World:update(self.LevelEndNow and dt*0.15 or dt);

	end

	if not self.Loaded then
		self.Loaded = true;
	end

	self.Stars:Think(dt);
	self.CoinAnimation:Think(dt);


end

function GAME:MousePressed(x, y, button, istouch, pressed)

end

function GAME:MouseReleased(x, y, button, istouch, pressed)

	if( self.NoFire or self.LevelEndNow ) then
		return;
	end


	if( self.Cannon and self.Loaded and SLING.Player.Data.BallsLeft > 0 ) then
		local bX, bY = self.Cannon.Pos.x, self.Cannon.Pos.y;
		local mX, mY = love.mouse.getPosition();
		if( mX > self.Cannon.Pos.x ) then
			return;
		end
		self.Bounces = 0;
		self.NoFire = true;
		local dist = math.distance(mX, mY, bX, bY);
		local angle = self.Cannon.Rotation;
		local ForceX, ForceY = math.cos(angle) * (50 * dist), math.sin(angle) * (50 * dist);
		self.Cannon:Fire(ForceX, ForceY);

		SLING.Player.Data.BallsLeft = SLING.Player.Data.BallsLeft-1;

		timer.Simple(2, function() self.NoFire = false end);

		if( SLING.Player.Data.BallsLeft == 0 ) then
			timer.Remove("game:noballend", true); -- no error, because we are constantly trying to remove and timer that might not have been created yet.
			timer.Create(7, 1, "game:noballend", function()
				if not self.LevelEnded then
					self.LevelEnd = true;
					self.Stars:Play(1);

					--self.NextLevelButton.Visible = true;
					self.RestartLevelButton.Visible = true;
					self.MainMenuButton.Visible = true;
					if( SLING.__COMPILE ) then
						love.ads.showBanner();
					end
				end
			end)
		end

	end

end

function GAME:KeyPressed(key, uni)
	if( key == "escape" ) then
		if( #SLING.GameState:GetAll() > 1 ) then
			SLING.GameState:Pop();
		end
	end
end

function GAME:Draw()

	love.graphics.setColor(0.5, 0.7, 0.5, 0);
	for k, v in pairs(self.Bounds) do
		love.graphics.polygon("fill", v.Body:getWorldPoints(v.Shape:getPoints()));
	end
	
	if( self.Background ) then
		love.graphics.setColor(1, 1, 1, 1);
		love.graphics.draw(self.Background.Image, 0, 0, 0, self.Background.Scale.x+.1, self.Background.Scale.y);
	end

	for k, v in pairs(self.Particles) do
		local px, py = v:getPosition();
		love.graphics.draw(v, px, py);
	end

	for i = 1, #self.Obstacles do

		local ob = self.Obstacles[i];
		local sp = self.Bodies[i];
		local obx, oby = 0, 0;
		if not( ob.Type == "Background" ) then
			obx, oby = math.floor(ob.Pos.x/self.GridSize.x)*self.GridSize.x, math.floor(ob.Pos.y/self.GridSize.y)*self.GridSize.y;
		end
		--if( ob.Type == "Squarre" ) then

		--	love.graphics.setColor(1,0,0,.2);
		--	love.graphics.rectangle("fill", obx, oby, self.GridSize.x, self.GridSize.y);

		--elseif( sp and ob.Type == "Triangle" or sp and ob.Type == "Square" ) then  -- Don't draw silly phys boxes please, they look shit.

		--	love.graphics.setColor(ob.Color);
		--	love.graphics.polygon("fill", sp.Body:getWorldPoints(sp.Shape:getPoints()));

		if( ob.Type == "Image" ) then

			love.graphics.setColor(1, 1, 1, 1);
			love.graphics.draw(self.Images[ob.Image],  (ob.Pos.x*self.GridSize.x)+self.GridSize.x/2, (ob.Pos.y*self.GridSize.y)+self.GridSize.y/2, math.rad(ob.Rotation), self.GridSize.x/self.Images[ob.Image]:getWidth(), self.GridSize.y/self.Images[ob.Image]:getHeight(),
																																	self.Images[ob.Image]:getWidth()/2, self.Images[ob.Image]:getHeight()/2);
		elseif( ob.Type == "Animation" ) then

			self.Animations[i]:Draw();

		elseif( ob.Type == "Cannon" ) then

			self.Cannon:Draw();

		end

	end

	if( self.LevelEnd ) then
		self.Stars:Draw()
	end

	self.CoinAnimation:Draw();

	love.graphics.setFont(self.Font);
	love.graphics.setColor(230/255, 191/255, 0, 1);
	love.graphics.print(SLING.Player.Data.Coins, self.cText[1]-2, self.cText[2]-2, math.rad(self.cText[3]));
	love.graphics.setColor(186/255, 134/255, 50/255, .7);
	love.graphics.print(SLING.Player.Data.Coins, self.cText[1], self.cText[2], math.rad(self.cText[3]));

	local bimg = SLING.BallTypes[SLING.Player.Data.SelectedSkin].Image;
	love.graphics.setColor( 1, 1, 1, 1 );
	love.graphics.draw(bimg, 48*SLING.Screen.Scale.x, 96*SLING.Screen.Scale.y, self.BallsLeftRotation, (32/bimg:getWidth())*SLING.Screen.Scale.x, (32/bimg:getWidth())*SLING.Screen.Scale.x, bimg:getWidth()/2, bimg:getHeight()/2);

	love.graphics.setFont(self.Font);
	love.graphics.setColor(230/255, 191/255, 0, 1);
	love.graphics.print(SLING.Player.Data.BallsLeft, self.cText[1]-2, (48*SLING.Screen.Scale.y)+self.cText[2]-2, math.rad(self.cText[3]));
	love.graphics.setColor(186/255, 134/255, 50/255, .7);
	love.graphics.print(SLING.Player.Data.BallsLeft, self.cText[1], (48*SLING.Screen.Scale.y)+self.cText[2], math.rad(self.cText[3]));

end

function GAME:ForceNextLevel()


	SLING.GameState:Pop();
	SLING.GameState:Push(SLING.Game, true);


end

function GAME:Shutdown()

	self.Cannon = nil;
	self.Animations = nil;
	self.Obstacles = nil;
	self.Images = nil;

	self.MagnetOn = nil;

	SLING.World:destroy();

	ui.Panels = {}

	if( SLING.__COMPILE ) then
		love.ads.hideBanner();
	end


end

return GAME;


