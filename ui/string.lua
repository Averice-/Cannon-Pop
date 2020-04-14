--[[
	Sling Hoops
]]--

local PANEL = {}

local Alphabet = { 	
					a = "a", b = "b", c = "c", d = "d", e = "e", f = "f", g = "g", h = "h", i = "i", j = "j",
					k = "k", l = "l", m = "m", n = "n", o = "o", p = "p", q = "q", r = "r", s = "s", t = "t",
					u = "u", v = "v", w = "w", x = "x", y = "y", z = "z" }
Alphabet["0"] = "0";
Alphabet["1"] = "1";
Alphabet["2"] = "2";
Alphabet["3"] = "3";
Alphabet["4"] = "4";
Alphabet["5"] = "5";
Alphabet["6"] = "6";
Alphabet["7"] = "7";
Alphabet["8"] = "8";
Alphabet["9"] = "9";

--					1 = "1", 2 = "2", 3 = "3", 4 = "4", 5 = "5", 6 = "6", 7 = "7", 8 = "8", 9 = "9", 0 = "0" 
--}

function PANEL:Init()
	--ScrW, ScrH = SLING.windowWidth, SLING.windowHeight;

	self.Pos = { x = 0, y = 0 };
	self.Size = { w = 0, h = 0 };
	self.Visible = false;
	self.Children = {};

	self.Text = {};
	self.TextColor = "Brown";
	self.TextSize = 16;
	self.TextSpacing = 0;

	self.Alpha = 1;




end

function PANEL:SetText(text)

	self.Text.String = string.lower(tostring(text));
	self.Text.Characters = {}
	self.Text.Positions = {}
	self.TextTotalLength = 0;

	local scalex = SLING.Screen.Width/800;
	local scaley = SLING.Screen.Height/480;

	local sub
	for i = 1, #text do

		sub = text:sub(i,i);

		if not self.Text.Characters[sub] then
			if not( Alphabet[sub] ) then
				self.TextTotalLength = self.TextTotalLength + 6;
			else
				self.Text.Characters[sub] = love.graphics.newImage("textures/ui/Font/"..self.TextColor.."/"..sub..".png");
			end
		end

		if Alphabet[sub] then
			local pos = {
				scalex = ((self.TextSize) / self.Text.Characters[sub]:getWidth())*scalex,
				scaley = ((self.TextSize) / self.Text.Characters[sub]:getHeight())*scaley
			}
			self.Text.Positions[i] = pos;

			self.TextTotalLength = self.TextTotalLength + (self.Text.Characters[sub]:getWidth() * pos.scalex) + self.TextSpacing;
		else
			self.Text.Positions[i] = {}
		end

	end

	self.Size = { w = self.TextTotalLength, h = self.Text.Characters[text:sub(1,1)]:getHeight() * self.Text.Positions[1].scaley };

end

function PANEL:Think(dt)
end

function PANEL:Draw()

	local len = self.Pos.x - (self.TextTotalLength/2);

	for i = 1, #self.Text.Positions do

		if not( Alphabet[self.Text.String:sub(i, i)] ) then
			len = len + 4;
		else
			love.graphics.setColor(1, 1, 1, self.Alpha);
			love.graphics.draw(self.Text.Characters[self.Text.String:sub(i, i)], len, self.Pos.y, 0,  self.Text.Positions[i].scalex, self.Text.Positions[i].scaley);

			len = len + (self.Text.Characters[self.Text.String:sub(i, i)]:getWidth() * self.Text.Positions[i].scalex) + self.TextSpacing;
			if( self.Text.String:sub(i, i) == "l" ) then
				len = len + 2;
			end
		end
	
	end

end

function PANEL:OnPress()

end

ui.Register("String", PANEL);

