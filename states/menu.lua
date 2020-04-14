--[[ 
	Sling Hoops
]]--

local MENU = new "CState";
	

--local ScrW, ScrH = SLING.windowWidth, SLING.windowHeight;
function MENU:Init()

	self.BGSound = love.audio.newSource("sounds/menu_bg.ogg", "static");
	self.BGSound:setLooping(true);
	self.BGSound:setVolume(0.8);

	self.CurrentPage = 1;

	local scalex = SLING.Screen.Width/800;
	local scaley = SLING.Screen.Height/480;

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

	math.randomseed(love.timer.getTime())
	self.RanBacks = {
		"forest.jpg",
		"medi.jpg",
		"mountain.jpg",
		"swamp.jpg"
	}
	self.Background = love.graphics.newImage("textures/backgrounds/"..self.RanBacks[math.random(1, #self.RanBacks)]);
	self.MadeButtons = {}

	local MainSound = love.audio.newSource("sounds/main_button.wav", "static");

	local Main = ui.CreatePanel("MainBoard");
	Main:SetPos(SLING.Screen.Width/2 - (Main.Image:getWidth() * Main.Scale.x)/2, SLING.Screen.Height/2 - (Main.Image:getHeight() * Main.Scale.y)/2);
	Main.Visible = true;
	Main.Alpha = .85
	self.MainContainer = Main;


	local NewGameButton = ui.CreatePanel("Button", Main);
	NewGameButton:SetSize((Main.Image:getWidth() * Main.Scale.x)*.75, 90*Main.Scale.y)
	NewGameButton:SetButtonImage("play");
	NewGameButton:SetPos((Main.Image:getWidth() * Main.Scale.x)/2 - (NewGameButton.Image.Up:getWidth()*NewGameButton.Image.Scale.scalex)/2, 140*Main.Scale.y);
	NewGameButton.Visible = true;
	NewGameButton.Alpha = .8;
	NewGameButton.Sound = MainSound;
	local oldPress = NewGameButton.OnRelease;
	NewGameButton.OnRelease = function()
		oldPress(NewGameButton);
		if not( NewGameButton.Pushed ) then
			timer.Simple(1, SLING.GameState.Push, SLING.GameState, SLING.Game, true);
			NewGameButton.Pushed = true;
		end
	end
	table.insert(self.MadeButtons, NewGameButton);

	local SelectLevelButton = ui.CreatePanel("Button", Main);
	SelectLevelButton:SetSize((Main.Image:getWidth() * Main.Scale.x)*.75, 90*Main.Scale.y);
	SelectLevelButton:SetButtonImage("levels");
	SelectLevelButton:SetPos((Main.Image:getWidth() * Main.Scale.x)/2 - (NewGameButton.Image.Up:getWidth()*NewGameButton.Image.Scale.scalex)/2, 250*Main.Scale.y);
	SelectLevelButton.Visible = true;
	SelectLevelButton.Alpha = .8;
	SelectLevelButton.Sound = MainSound
	local oldPress = SelectLevelButton.OnRelease
	SelectLevelButton.OnRelease = function()
		oldPress(SelectLevelButton);
		self:LevelSelect();
	end
	table.insert(self.MadeButtons, SelectLevelButton);

	local SelectSkinButton = ui.CreatePanel("Button", Main);
	SelectSkinButton:SetSize((Main.Image:getWidth() * Main.Scale.x)*.75, 90*Main.Scale.y);
	SelectSkinButton:SetButtonImage("balls");
	SelectSkinButton:SetPos((Main.Image:getWidth() * Main.Scale.x)/2 - (NewGameButton.Image.Up:getWidth()*NewGameButton.Image.Scale.scalex)/2, 360*Main.Scale.y);
	SelectSkinButton.Visible = true;
	SelectSkinButton.Alpha = 0.8;
	SelectSkinButton.Sound = MainSound;
	local oldPress = SelectSkinButton.OnRelease
	SelectSkinButton.OnRelease = function()
		oldPress(SelectSkinButton);
		self:BallSelect();
	end
	table.insert(self.MadeButtons, SelectSkinButton);

	local Tips = ui.CreatePanel("Button", Main);
	Tips:SetSize((Main.Image:getWidth() * Main.Scale.x)*.75, 90*Main.Scale.y);
	Tips:SetButtonImage("tips");
	Tips:SetPos((Main.Image:getWidth() * Main.Scale.x)/2 - (NewGameButton.Image.Up:getWidth()*NewGameButton.Image.Scale.scalex)/2, 470*Main.Scale.y);
	Tips.Visible = true;
	Tips.Alpha = 0.8;
	Tips.Sound = MainSound;
	local oldPress = Tips.OnRelease
	Tips.OnRelease = function()
		oldPress(Tips);
		self:ShowTips();
	end
	table.insert(self.MadeButtons, Tips);

	local Consent = ui.CreatePanel("Button", Main);
	Consent:SetSize((Main.Image:getWidth() * Main.Scale.x)*.75, 90*Main.Scale.y);
	Consent:SetButtonImage("eu ad privacy");
	Consent:SetPos((Main.Image:getWidth() * Main.Scale.x)/2 - (NewGameButton.Image.Up:getWidth()*NewGameButton.Image.Scale.scalex)/2, 580*Main.Scale.y);
	Consent.Visible = true;
	Consent.Alpha = 0.8;
	Consent.Sound = MainSound;
	local oldPress = Consent.OnRelease
	Consent.OnRelease = function()
		oldPress(Consent);
		if( SLING.__COMPILE ) then
			--print("ASKING TO CHANGE CONSENT");
			love.ads.changeEUConsent();
		end
	end
	table.insert(self.MadeButtons, Consent);


	local Exit = ui.CreatePanel("Button");
	Exit:SetSize(32, 32);
	Exit:SetButtonImage(love.graphics.newImage("textures/ui/exit.png"));
	Exit:SetPos(SLING.Screen.Width-(64*SLING.Screen.Scale.x), 32*SLING.Screen.Scale.y);
	Exit.Visible = true;
	local oldres = Exit.OnRelease;
	Exit.OnRelease = function()
			oldres(Exit)
			love.event.quit();
		end

	self.BGSound:play();

	if( SLING.__COMPILE ) then
		love.ads.showBanner();
	end


end

function MENU:PostInit()
end

function MENU:ShowTips()

	for i = 1, #self.MadeButtons do
		self.MadeButtons[i].Visible = false;
	end

	if not self.TipsContainer then

		self.TipsContainer = ui.CreatePanel("Container", self.MainContainer);
		self.TipsContainer:SetSize((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*.9, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.8);
		self.TipsContainer:SetPos((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*0.05, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.15);
		self.TipsContainer.Alpha = 0;

		local TipText = [[
HOW-TO-PLAY
Find the buttons in the levels, you must hit all
of them with a ball or a physics object in order to
complete each level.
Unlock new balls as you earn coins and quickly swap
between them in-game from the arsenal menu
in the top right corner.

AIMING:
Use your finger to aim from BEHIND the cannon, 
release your finger to fire!

BALLS:
Try to use the right ball for the job, some balls do 
not pop when hitting the spikes!
Heavy balls can break wooden crates, use them if you 
need to unblock a path.

GUIDES:
Some physics objects can push the buttons for you to 
progress, keep an eye out for them!
Buttons can be hidden behind bushes try to spot them 
before you start firing.
Some levels require extreme precision, use a slower
ball like the Beachball if you are over-shooting your
targets!

Cannon Pop created by Shard Studio 2020]]

		local font = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 10*SLING.Screen.Scale.y)
		self.TipText = ui.CreatePanel("Label", self.TipsContainer);
		self.TipText.Font = font;
		self.TipText:SetText(TipText);
		self.TipText:SetPos((-5*SLING.Screen.Scale.x), 10)
		--self.TipText:Center()
		self.TipText.AddSecondColor = true;
		self.TipText.SecondColor = {230/255, 191/255, 0, 1}
		self.TipText.Color = {186/255, 134/255, 50/255, .7}

		self.TipText.Visible = true;

		self.BackButtonTip = ui.CreatePanel("Button", self.MainContainer)
		self.BackButtonTip:SetSize(32, 32); -- add self.MainContainer.Scale if wrong!.
		self.BackButtonTip:SetButtonImage(love.graphics.newImage("textures/ui/backward.png"));
		self.BackButtonTip:SetPos(self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x - (40*SLING.Screen.Scale.x), 12*SLING.Screen.Scale.y);
		local oldres = self.BackButtonTip.OnRelease;
		self.BackButtonTip.OnRelease = function()
			oldres(self.BackButtonTip)
			self.TipsContainer.Visible = false;
			self.BackButtonTip.Visible = false;
			for i = 1, #self.MadeButtons do
				self.MadeButtons[i].Visible = true;
			end
		end
	else

		self.BackButtonTip.Visible = true;
		self.TipsContainer.Visible = true;

	end

end

function MENU:BallSelect()
	local BuyImg = love.graphics.newImage("textures/ui/buy.png");
	local SelImg = love.graphics.newImage("textures/ui/select.png");

	for i = 1, #self.MadeButtons do
		self.MadeButtons[i].Visible = false;
	end

	if not self.BallContainer then


		self.BallContainer = ui.CreatePanel("Container", self.MainContainer);
		self.BallContainer:SetSize((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*.9, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.8);
		self.BallContainer:SetPos((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*0.05, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.15);
		self.BallContainer.Alpha = 0;

		self.BackButton = ui.CreatePanel("Button", self.MainContainer)
		self.BackButton:SetSize(32, 32); -- add self.MainContainer.Scale if wrong!.
		self.BackButton:SetButtonImage(love.graphics.newImage("textures/ui/backward.png"));
		self.BackButton:SetPos(self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x - (40*SLING.Screen.Scale.x), 12*SLING.Screen.Scale.y);
		local oldres = self.BackButton.OnRelease;
		self.BackButton.OnRelease = function()
			oldres(self.BackButton)
			self.BallContainer.Visible = false;
			self.BackButton.Visible = false;
			for i = 1, #self.MadeButtons do
				self.MadeButtons[i].Visible = true;
			end
		end

		self.BallBoxes = {}
		local cX, cY = 0, 0;
		local amx = math.floor((self.BallContainer.Size.w-40)/3);
		local amy = math.floor((self.BallContainer.Size.h-40)/3);
		for k, v in pairs(SLING.BallTypes) do

			local box = ui.CreatePanel("Container", self.BallContainer);
			box:SetSize(amx, amy);
			box:SetPos(10+(amx*cX)+(cX*10), 10+(amy*cY)+(cY*10));
			box.Color = {230/255, 191/255, 0, 1};
			if( SLING.Player.Data.SelectedSkin == k ) then
				self.BallBoxSelected = box;
				box.Fill = true;
				box.Alpha = .5;
			end


			local img = ui.CreatePanel("Image", box);
			img:SetSize(amx-30, amx-30);
			img:SetPos(15,5);
			img:SetImage(v.Image);

			local label = ui.CreatePanel("Label", box);
			label:SetText(v.Weight.."\n"..v.Price);
			label:SetPos(amx/2, amy-(30*SLING.Screen.Scale.y));
			label:Center();
			label.AddSecondColor = true;
			label.SecondColor = {230/255, 191/255, 0, 1}
			label.Color = {186/255, 134/255, 50/255, .7}

			local buy = ui.CreatePanel("Button", box);
			buy:SetSize(32, 32); -- self.MainContainer.Scale if wrong!.
			buy:SetButtonImage(SLING.Player:HasSkin(k) and SelImg or BuyImg);
			buy:SetPos(amx-(30*SLING.Screen.Scale.x), 0-(8*SLING.Screen.Scale.y));
			local oldres = buy.OnRelease
			buy.OnRelease = function()
				oldres(buy);
				if( SLING.Player:HasSkin(k) ) then
					SLING.Player.Data.SelectedSkin = k;
					self.BallBoxSelected.Fill = false
					self.BallBoxSelected.Alpha = 1;
					self.BallBoxSelected = buy.Parent;
					self.BallBoxSelected.Fill = true;
					self.BallBoxSelected.Alpha = .5
				else
					if( SLING.Player:BuySkin(k) ) then
						buy:SetSize(32, 32);
						buy:SetButtonImage(SelImg);
					end
				end
			end

			box.OnRelease = function()
				if( SLING.Player:HasSkin(k) ) then
					self.BallBoxSelected.Fill = false;
					self.BallBoxSelected.Alpha = 1;
					self.BallBoxSelected = buy.Parent;
					self.BallBoxSelected.Fill = true;
					self.BallBoxSelected.Alpha = .5;
					SLING.Player.Data.SelectedSkin = k;
				end
			end

			label.OnRelease = box.OnRelease;
			img.OnRelease = box.OnRelease;
			table.insert(self.BallBoxes, box);

			cX = cX+1;
			if( cX == 3 ) then
				cX = 0;
				cY = cY + 1;
			end

		end

	else

		self.BallContainer.Visible = true;
		self.BackButton.Visible = true;

	end

end

function MENU:LevelSelect()

	for i = 1, #self.MadeButtons do
		self.MadeButtons[i].Visible = false;
	end

	-- Let's say 100 levels for now.
	local pages = 50/25;
	local curPage = 1;


	if not self.LevelContainer then

		self.LevelContainer = ui.CreatePanel("Container", self.MainContainer);
		self.LevelContainer:SetSize((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*.9, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.8);
		self.LevelContainer:SetPos((self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x)*0.05, (self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)*.15);
		self.LevelContainer.Alpha = 0;

		self.ForwardPage = ui.CreatePanel("Button");
		self.ForwardPage:SetSize(32, 32);
		self.ForwardPage:SetButtonImage(love.graphics.newImage("textures/ui/forward1.png"));
		self.ForwardPage:SetPos(self.MainContainer.Pos.x + (self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x) + 32*SLING.Screen.Scale.x, self.MainContainer.Pos.y+(self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)/2 -(16*SLING.Screen.Scale.y));
		local oldp = self.ForwardPage.OnRelease;
		self.ForwardPage.OnRelease = function()
			oldp(self.ForwardPage);
			self.CurrentPage = clamp(self.CurrentPage + 1, 1, pages);
			for i = 1, #self.LevelBoxes do
				self.LevelContainer:RemoveChild(self.LevelBoxes[i]);
			end
			self.LevelBoxes = {};
			createlevboxes();
		end
		self.ForwardPage.Visible = true;

		self.BackPage = ui.CreatePanel("Button");
		self.BackPage:SetSize(32, 32);
		self.BackPage:SetButtonImage(love.graphics.newImage("textures/ui/backward1.png"));
		self.BackPage:SetPos(self.MainContainer.Pos.x - (64*SLING.Screen.Scale.x), self.MainContainer.Pos.y+(self.MainContainer.Image:getHeight()*self.MainContainer.Scale.y)/2 -(16*SLING.Screen.Scale.y));
		local oldp = self.BackPage.OnRelease;
		self.BackPage.OnRelease = function()
			oldp(self.BackPage);
			self.CurrentPage = clamp(self.CurrentPage - 1, 1, pages);
			for i = 1, #self.LevelBoxes do
				self.LevelContainer:RemoveChild(self.LevelBoxes[i]);
			end
			self.LevelBoxes = {};
			createlevboxes();
		end
		self.BackPage.Visible = true;



		self.BackButtonLev = ui.CreatePanel("Button", self.MainContainer)
		self.BackButtonLev:SetSize(32, 32); -- add self.MainContainer.Scale if wrong!.
		self.BackButtonLev:SetButtonImage(love.graphics.newImage("textures/ui/backward.png"));
		self.BackButtonLev:SetPos(self.MainContainer.Image:getWidth()*self.MainContainer.Scale.x - (40*SLING.Screen.Scale.x), 12*SLING.Screen.Scale.y);
		local oldres = self.BackButtonLev.OnRelease;
		self.BackButtonLev.OnRelease = function()
			oldres(self.BackButtonLev)
			self.LevelContainer.Visible = false;
			self.BackButtonLev.Visible = false;
			self.BackPage.Visible = false;
			self.ForwardPage.Visible = false;
			for i = 1, #self.MadeButtons do
				self.MadeButtons[i].Visible = true;
			end
		end

		self.LevelBoxes = {}
		function createlevboxes()
			local amx = math.floor((self.LevelContainer.Size.w-(30*SLING.Screen.Scale.x))/5)
			local amy = math.floor((self.LevelContainer.Size.h-(30*SLING.Screen.Scale.y))/5);
			local alpha = 1;
			local cX, cY = 0, 0;
			for b = 1, 25 do
				if( b + ( 25 * (self.CurrentPage - 1) ) > SLING.Player.Data.LevelReached ) then
					alpha = 0.5;
				else
					alpha = 1;
				end

				local img = ui.CreatePanel("Button", self.LevelContainer);
				img:SetSize(amx-(10*SLING.Screen.Scale.x), amx-(10*SLING.Screen.Scale.y));
				img.TextSize = 12;
				img.Alpha = alpha;
				img:SetButtonImage(b+(25*(self.CurrentPage-1)));
				img:SetPos(5+(amx*cX)+(cX*(10*SLING.Screen.Scale.x)),5+(amy*cY)+(cY*(10*SLING.Screen.Scale.y)));
				local oldpress = img.OnRelease;
				img.OnRelease = function()
					if( b + ( 25 * (self.CurrentPage - 1) ) <= SLING.Player.Data.LevelReached ) then
						oldpress(img);
						SLING.Player.Data.SelectedLevel = b + ( 25 * (self.CurrentPage - 1) );
						self.LevelContainer.Visible = false;
						self.BackButtonLev.Visible = false;
						self.BackPage.Visible = false;
						self.ForwardPage.Visible = false;
						for i = 1, #self.MadeButtons do
							self.MadeButtons[i].Visible = true;
						end
					end
				end
				table.insert(self.LevelBoxes, img);

				cX = cX+1;
				if( cX == 5 ) then
					cX = 0;
					cY = cY + 1;
				end

			end
		end
		createlevboxes();

	else

		self.LevelContainer.Visible = true;
		self.BackButtonLev.Visible = true;
		self.ForwardPage.Visible = true;
		self.BackPage.Visible = true;

	end

end



textpos = 0;
textdir = 1;
function MENU:Think(dt)

	--[[if( textdir == 1 ) then
		if( textpos < 10 ) then
			textpos = textpos+1
			if( math.abs(textpos) % 2 == 0 ) then
				self.cText[2] = self.cText[2] + 1;
			else
				self.cText[3] = self.cText[3] + .15;
			end
		else
			textdir = 0
		end
	elseif( textdir == 0 ) then
		if( textpos > -10 ) then
			textpos = textpos-1;
			if( math.abs(textpos) % 2 == 0 )then
				self.cText[2] = self.cText[2] - 1;
			else
				self.cText[3] = self.cText[3] -.15;
			end
		else
			textdir = 1;
		end
	end--]]
	self.CoinAnimation:Think(dt);

end

function MENU:MousePressed(x, y, button, istouch, pressed)
end


function MENU:KeyPressed(key, uni)
	if( key == "escape" ) then
		if( #SLING.GameState:GetAll() > 1 ) then
			SLING.GameState:Pop();
		end
	end
	if( key == "r" ) then

	elseif( key == "g" ) then

	end
end


function MENU:Draw()

	local scalex, scaley = SLING.Screen.Width/self.Background:getWidth(), SLING.Screen.Height/self.Background:getHeight();
	love.graphics.setColor(1, 1, 1, 1);
	love.graphics.draw(self.Background, 0, 0, 0, scalex+.1, scaley);

	self.CoinAnimation:Draw()

	love.graphics.setFont(self.Font);
	love.graphics.setColor(230/255, 191/255, 0, 1);
	love.graphics.print(SLING.Player.Data.Coins, self.cText[1]-2, self.cText[2]-2, math.rad(self.cText[3]));
	love.graphics.setColor(186/255, 134/255, 50/255, .7);
	love.graphics.print(SLING.Player.Data.Coins, self.cText[1], self.cText[2], math.rad(self.cText[3]));

	
end

-- FROM HERE ON, NO CROSSOVER UI ELEMENTS BECAUSE I'M LAZY RIGHT NOW!
function MENU:Shutdown()
	if( SLING.__COMPILE ) then
		love.ads.hideBanner();
	end
	self.BGSound:stop();
	self.Background = nil;

	self.BallContainer = nil;
	self.LevelContainer = nil;
	self.TipsContainer = nil;
	ui.Panels = {}
end

return MENU;


