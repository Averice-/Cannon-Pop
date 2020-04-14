--[[
	Sling Hoops
]]--

class "CBall";

function CBall:Init()

end

function CBall:Create(r, x, y)
	
	local sx = SLING.Screen.Scale.x
	local sy = SLING.Screen.Scale.y

	local aball = SLING.BallTypes[SLING.Player.Data.SelectedSkin];

	self.Body = love.physics.newBody(SLING.World, x or 100, y or 100, "dynamic");
	self.Shape = love.physics.newCircleShape(r*sx);
	self.Fixture = love.physics.newFixture(self.Body, self.Shape, 1);
	self.Fixture:setRestitution(aball.Restitution);
	self.Fixture:setUserData("basketball");
--	if not self.Image then -- why did i do this?
		self.DefaultMass = self.Body:getMass();
		self.Image = aball.Image;
		self.Body:setMass(self.Body:getMass()*aball.MassMultiplyer)
		self.Scale = {
			x = (r*2/self.Image:getWidth())*sx,
			y = (r*2/self.Image:getHeight())*sy
		}
--	end

	return self;

end



function CBall:Hit(s)


end

function CBall:Draw()

	if( self.Body ) then
  		love.graphics.setColor(1, 1, 1, 1);
  		love.graphics.draw(self.Image, self.Body:getX(), self.Body:getY(), self.Body:getAngle(), self.Scale.x, self.Scale.x, self.Image:getWidth()/2, self.Image:getHeight()/2);
 	end

end

function CBall:Delete()
	self.Body:destroy();
	self.Body = nil;
	self.Shape = nil;
	self.Fixture = nil;
end

function CBall:Shutdown()
end