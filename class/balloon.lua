--[[
	Sling Hoops
]]--

class "CBalloon";

function CBalloon:Init()

	self.PullForce = 100*SLING.Screen.Scale.x;

	self.Pos = { x = 0, y = 0 };

end

function CBalloon:Create(x, y, a)

	self.Pos = { x = x, y = y };
	self.Anim = a;

end

function CBalloon:Update(dt)

	if( self.Anim.Phys and self.Anim.Phys.Body ) then

		self.Anim.Phys.Body:applyForce(0, 0-self.PullForce);

	end

end

function CBalloon:Shutdown()
end