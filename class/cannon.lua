--[[
	Sling Hoops
]]--

class "CCannon";

function CCannon:Init()

	local scalex = SLING.Screen.Scale.x
	local scaley = SLING.Screen.Scale.y

	self.Cannon = love.graphics.newImage("textures/objects/Cannon 001.png");
	self.CannonStand = love.graphics.newImage("textures/objects/Pivot Cannon 001.png");

	self.Scale = { x = .04*scalex, y = .04*scaley };
	self.Pos = { x = 0, y = 0 };
	self.Rotation = 0;
	self.Alpha = 1;

	self.BallRadius = 10;


	self.LastDT = 0;

	self.Ball = new "CBall";

	self.FakeBall = new "CBall";
	self.FakeBall:Create(SLING.BallTypes[SLING.Player.Data.SelectedSkin].Radius, -100, -100);
	self.FakeBall.Body:setActive(false);


	self.CannonSound = love.audio.newSource("sounds/launch.mp3", "static");

	self.FirstFire = true;

end


function CCannon:SetPos(x, y)
	local Res = SLING.Settings.WorldRes
	self.Pos = { x = x, y = y };

	self.CannonPhysics = {}
	self.CannonPhysics.Body = love.physics.newBody(SLING.World, self.Pos.x, self.Pos.y, "static");
	self.CannonPhysics.Shape = love.physics.newPolygonShape(0-(self.Cannon:getWidth()*.3)*self.Scale.x, 0-(self.Cannon:getHeight()*.9)*self.Scale.y,
															 0+(self.Cannon:getWidth()*.7)*self.Scale.x, 0-(self.Cannon:getHeight()*.9)*self.Scale.y,
															 0+(self.Cannon:getWidth()*.7)*self.Scale.x, 0+(self.Cannon:getHeight()*.1)*self.Scale.y,
															 0-(self.Cannon:getWidth()*.3)*self.Scale.x, 0+(self.Cannon:getHeight()*.1)*self.Scale.y	);
	self.CannonPhysics.Fixture = love.physics.newFixture(self.CannonPhysics.Body, self.CannonPhysics.Shape, 1);
	self.CannonPhysics.Fixture:setRestitution(Res); 

	self.StandPhysics = {}
	self.StandPhysics.Body = love.physics.newBody(SLING.World, self.Pos.x, self.Pos.y, "static");
	self.StandPhysics.Shape = love.physics.newPolygonShape(	0-(self.CannonStand:getWidth()/2)*self.Scale.x, 0,
															0+(self.CannonStand:getWidth()/2)*self.Scale.x, 0,
															0-(self.CannonStand:getWidth()/2)*self.Scale.x, 0+(self.CannonStand:getHeight())*self.Scale.y,
															0+(self.CannonStand:getWidth()/2)*self.Scale.x, 0+(self.CannonStand:getHeight())*self.Scale.y	);
	self.StandPhysics.Fixture = love.physics.newFixture(self.StandPhysics.Body, self.StandPhysics.Shape, 1);
	self.StandPhysics.Fixture:setRestitution(Res);

	self.SpawnerPhysics = {}
	self.SpawnerPhysics.Shape = love.physics.newPolygonShape(	0+(self.Cannon:getWidth()*.8)*self.Scale.x, 0-(self.Cannon:getHeight()*.5)*self.Scale.y,
																2+(self.Cannon:getWidth()*.8)*self.Scale.x, 0-(self.Cannon:getHeight()*.5)*self.Scale.y,
																2+(self.Cannon:getWidth()*.8)*self.Scale.x, 2-(self.Cannon:getHeight()*.5)*self.Scale.y,
																0+(self.Cannon:getWidth()*.8)*self.Scale.x, 2-(self.Cannon:getHeight()*.5)*self.Scale.y	);
	self.SpawnerPhysics.Fixture = love.physics.newFixture(self.CannonPhysics.Body, self.SpawnerPhysics.Shape, 1);
	self.SpawnerPhysics.Fixture:setRestitution(Res);


	self.SpawnerPhysics.Fixture:setCategory(2);
	self.SpawnerPhysics.Fixture:setMask(1, 2, 3, 4, 5, 6);

	self.CannonPhysics.Fixture:setCategory(2);
	self.CannonPhysics.Fixture:setMask(2);

	self.StandPhysics.Fixture:setCategory(2);
	self.StandPhysics.Fixture:setMask(2);

end

function CCannon:Fire(fx, fy)

	local cp = { self.CannonPhysics.Body:getWorldPoints(self.SpawnerPhysics.Shape:getPoints()) }

	if( self.Ball.Body ) then
		self.Ball:Delete()
	end

	self.Ball:Create(SLING.BallTypes[SLING.Player.Data.SelectedSkin].Radius, cp[1], cp[2]);
	self.Ball.Fixture:setCategory(1)
	love.audio.play(self.CannonSound);
	self.Ball.Body:applyForce(fx, fy);

end

local cp
function CCannon:Think(dt)
	self.LastDT = dt;
end

--function CCannon:CalculateTrajectory()
	--local Positions = {}
	--for i = 1, 60 do
		--x = 

function getTrajectoryPoint(startingPosition, startingVelocity, n , mass)
      --velocity and gravity are given per second but we want time step values here
      local t = 1 / 60 -- seconds per time step (at 60fps)
	  local gravityX, gravityY = SLING.World:getGravity() 
      local stepVelocity = { x = t * startingVelocity.x/mass, y = t * startingVelocity.y/mass }; -- m/s
      local stepGravity = { x = t * t * gravityX, y = t * t * gravityY }-- m/s/s

      return startingPosition.x + stepVelocity.x*(t*n) + gravityX*(t*n)*(t*n)*0.5, startingPosition.y + stepVelocity.y*(t*n) + gravityY*(t*n)*(t*n)*0.5

  	 -- return    startingPosition.x + n * stepVelocity.x + 0.5 * (n*n*n) * stepGravity.x,
  	 -- 			startingPosition.y + n * stepVelocity.y + 0.5 * (n*n*n) * stepGravity.y     
end

 --start + startVelocity*time + Physics.gravity*time*time*0.5f;
function CCannon:Draw()

	local scalex = SLING.Screen.Scale.x;
	local scaley = SLING.Screen.Scale.y;

	love.graphics.setColor(1, 1, 1, self.Alpha);

	local bX, bY = self.Pos.x, self.Pos.y;
	local mX, mY = love.mouse.getPosition();
	local dist = math.distance(mX, mY, bX, bY);
	local angle = self.Rotation;
	local ForceX, ForceY = math.cos(angle) * (50 * dist), math.sin(angle) * (50 * dist);
	local cp = { self.CannonPhysics.Body:getWorldPoints(self.SpawnerPhysics.Shape:getPoints()) }
	--if( self.Ball.Body ) then
	love.graphics.setColor(.8, .4, .4, 1);
	love.graphics.setPointSize(4);
	local px, py
		for i = 1, 80 do
			px, py = getTrajectoryPoint({x = cp[1], y = cp[2]}, {x = ForceX, y = ForceY}, i, self.FakeBall.Body:getMass())
			--px, py = px*scalex, py*scaley
			love.graphics.points(px, py);
			love.graphics.setPointSize(math.floor((80-i)/10));
		end 
	--end

	-- CANNON DEBUG GRAPHICS
		--love.graphics.polygon("line", self.CannonPhysics.Body:getWorldPoints(self.CannonPhysics.Shape:getPoints()));
		--love.graphics.polygon("line", self.StandPhysics.Body:getWorldPoints(self.StandPhysics.Shape:getPoints()));
		--love.graphics.points(self.CannonPhysics.Body:getWorldPoints(self.SpawnerPhysics.Shape:getPoints()));
	love.graphics.setColor(1, 1, 1, 1);

	love.graphics.draw(self.Cannon, self.Pos.x, self.Pos.y, self.Rotation, self.Scale.x, self.Scale.y, self.Cannon:getWidth()*.3, self.Cannon:getHeight()*.9);
	love.graphics.draw(self.CannonStand, self.Pos.x, self.Pos.y, 0, self.Scale.x, self.Scale.y, self.CannonStand:getWidth()/2);

	self.Ball:Draw();

end

function CCannon:Shutdown()
end