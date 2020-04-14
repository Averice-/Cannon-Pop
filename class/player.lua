--[[
	Sling Hoops
]]--

class "CPlayer";

function CPlayer:Init()

	self.Data = {

		Skins = {"cannonball", "basketball"},
		Coins = 20000,

		Consent = false,

		LevelReached = 1,
		SelectedLevel = 1,

		Collectables = {},


		EU_CONSENT = false,
		InGame = false,

		MaxBalls = 6,
		BallsLeft = 6,

		SelectedSkin = "cannonball"

	}


end

function CPlayer:GiveCoins(num)
	self.Data.Coins = math.floor(self.Data.Coins + num);
end

function CPlayer:GetCoins()
	return self.Data.Coins;
end

function CPlayer:HasEnough(amnt)
	return self.Data.Coins >= amnt;
end

function CPlayer:HasSkin(name)
	local yes = false;
	for i = 1, #self.Data.Skins do
		yes = self.Data.Skins[i] == name or false;
		if( yes ) then
			break;
		end
	end
	return yes;
end

function CPlayer:BuySkin(name)
	if( self:HasEnough(SLING.BallTypes[name].Price) and not self:HasSkin(name) ) then
		table.insert(self.Data.Skins, name);
		self:GiveCoins(-SLING.BallTypes[name].Price);
		return true
	else
		return false
	end
end

function CPlayer:SetSkin(name)
	if( self:HasSkin(name) ) then
		self.SelectedSkin = name;
	end
end

function CPlayer:Save()

	local dat = json.encode(self.Data);
	love.filesystem.write("player.txt", dat);

end

function CPlayer:Load()

	if( love.filesystem.getInfo("player.txt") ) then
		local dat = json.decode(love.filesystem.read("player.txt"));
		self.Data = dat;
	end

end



function CPlayer:ScoreCalculator(min_score, score, num_btns)

	local how_many = self.Data.MaxBalls - num_btns;
	if( self.Data.BallsLeft == 0 ) then
		return min_score;
	end

	local retscore = math.floor(score * (self.Data.BallsLeft/how_many))
	return retscore, retscore/score;
	
end



function CPlayer:Shutdown()

end