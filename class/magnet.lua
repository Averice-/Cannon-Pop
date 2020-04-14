--[[
	Sling Hoops
]]--

class "CMagnet";

function CMagnet:Init()

	self.PullForce = 650*SLING.Screen.Scale.x;

	self.Pos = { x = 0, y = 0 };
	self.Rotation = 0;

end

function CMagnet:Create(x, y, r, s)

	self.Pos = { x = x, y = y };
	self.Rotation = r or self.Rotation;
	self.PullForce = s or self.PullForce;

end

local magnetic = {
	cannonball = 1,
	bowlingball = 1
}


function CMagnet:Update(dt)

	if( SLING.Game.MagnetOn and SLING.Game.MagnetOn.Pushed == false ) then
		return;
	end
	if( SLING.Game and SLING.Game.Cannon and SLING.Game.Cannon.Ball and SLING.Game.Cannon.Ball.Body ) then

		--if( magnetic[SLING.Player.Data.SelectedSkin] ) then

			local ball = SLING.Game.Cannon.Ball;

			local mx, my = self.Pos.x, self.Pos.y;
			local bx, by = ball.Body:getX(), ball.Body:getY();

			local dist = math.distance(bx, by, mx, my);

			if( dist < 300*SLING.Screen.Scale.x ) then

				local angle = math.atan2(my-by, mx-bx);

				local fx, fy = math.cos(angle) * (self.PullForce * (50/(dist/SLING.Screen.Scale.x))), math.sin(angle) * (self.PullForce * (50/(dist/SLING.Screen.Scale.y)));

				ball.Body:applyForce(fx, fy);



			end
		--end
	end

	if( SLING.Game and SLING.Game.CannonBalls[1] ) then
		local cball, mx, my, bx, by;
		for i = 1, #SLING.Game.CannonBalls do
			cball = SLING.Game.CannonBalls[i];

			mx, my = self.Pos.x, self.Pos.y;
			bx, by = cball.Phys.Body:getX(), cball.Phys.Body:getY();

			local dist = math.distance(bx, by, mx, my);
			if( dist < 300*SLING.Screen.Scale.x ) then

				local angle = math.atan2(my-by, mx-bx);
				local fx, fy = math.cos(angle) * (self.PullForce * (50/(dist/SLING.Screen.Scale.x))), math.sin(angle) * (self.PullForce * (50/(dist/SLING.Screen.Scale.y)));

				if( cball.Phys and cball.Phys.Body ) then
					cball.Phys.Body:applyForce(fx, fy);
				end

			end

		end

	end

end

function CMagnet:Shutdown()
end