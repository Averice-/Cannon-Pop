--[[
	Sling Hoops
]]--

class "CAnimation";

-- The most basic animation system you will ever see.. you're welcome!

function CAnimation:Init()

	self.Frames = {};
	self.CurrentFrame = 1;
	self.TotalTime = 1;
	self.CurTime = 0 ;

	self.IsAnim = true; -- for physics touches.. i know.. don't look at me.
	self.Type = "BaseAnimation";

	self.Running = false;
	self.ToFrame = 99;
	self.TimeBetween = 0.1;

	self.Pos = { x = 0, y = 0 };
	self.Size = { w = 0, h = 0 };
	self.Color = {1, 1, 1, 1}

	self.Scale = { x = 1, y = 1 };
	self.Origin = { x = 0, y = 0 };
	self.Rotation = 0;

	self.Wobbles = { x = 0, y = 0 };

	self.Looped = false;

	self.CurPulse = 0;
	self.PulseDir = 1;

end

function CAnimation:SetColor(r, g, b, a)
	self.Color = { r, g, b, a or 1};
end

function CAnimation:NewAnimation(images, time)
	for i = 1, #images do
		table.insert(self.Frames, love.graphics.newImage(images[i]))
	end
	self.TotalTime = time;
	self.TimeBetween = time/#images;
	self.CurTime = 0;
	self.ToFrame = #images;
end

function CAnimation:SetRotation(n)
	self.Rotation = n or 0;
end

local mt = love.timer.getTime
function CAnimation:Play(toframe,fr)

	local to_frame = toframe and clamp(toframe, 1, #self.Frames) or false;
	self.Running = true;
	self.ToFrame = to_frame or #self.Frames;
	self.CurTime = mt();

	if( self.CurrentFrame == 1 ) then
		self:OnStart()
	end
end

function CAnimation:Loop()
	self.Looped = true;
end

function CAnimation:SetPos(x, y)
	self.Pos = { x = x or 0, y = y or 0 };
end

function CAnimation:SetSize(w, h)
	self.Size = { w = w or 0, h = h or 0 };
end

function CAnimation:SetScale(x, y)
	self.Scale = { x = x or 1, y = y or 1 };
end

function CAnimation:SetOrigin(x, y)
	self.Origin = { x = x or 0, y = y or 0 }
end

function CAnimation:Reset()
	self.Running = false;
	self.ToFrame = #self.Frames;
	self.CurrentFrame = 1;
end

function CAnimation:CenterOrigin()
	self.Origin = { x = self.Frames[1]:getWidth()/2, y = self.Frames[1]:getHeight()/2 };
end

function CAnimation:ApplyPhysics(world, s, types, circle, radius)
	local scale = s or 1;
	local Res = SLING.Settings.WorldRes
	local firstFrame = self.Frames[1];
	local w, h = (firstFrame:getWidth()*self.Scale.x)/2, (firstFrame:getHeight()*self.Scale.y)/2;
	w, h = w*scale, h*scale;
	self.Phys = {}
	self.Phys.Body = love.physics.newBody(world, self.Pos.x, self.Pos.y, types);
	if circle then
		self.Rad = radius;
		self.IsCircle = true;
		self.Phys.Shape = love.physics.newCircleShape(radius*SLING.Screen.Scale.x)
	else
		self.Phys.Shape = love.physics.newPolygonShape(	0-w, 0-h, --tl
														0+w, 0-h, -- tr
														0+w, 0+h, -- br
														0-w, 0+h) -- bl
	end
	self.Phys.Fixture = love.physics.newFixture(self.Phys.Body, self.Phys.Shape, 1);
	self.Phys.Fixture:setRestitution(Res);

	self.Phys.Body:setAngle(math.rad(self.Rotation));
	self.Phys.Fixture:setUserData(self);
end


function CAnimation:Think(dt)

	if( self.CurTime < mt() and self.Running and self.CurrentFrame < self.ToFrame ) then
		self.CurTime = mt() + self.TimeBetween;
		self.CurrentFrame = self.CurrentFrame+1;
		self:OnFrameChange();
	elseif( self.CurrentFrame == self.ToFrame ) then
		self.Running = false;
		if( self.CurrentFrame ~= #self.Frames ) then
			self:OnPause();
		end
	end

	if( self.Pulse ) then
		if( self.PulseDir == 1 ) then
			if( self.CurPulse < self.Pulse.size ) then
				self.CurPulse = self.CurPulse + self.Pulse.speed;
				self.Scale.x = self.Scale.x + self.Pulse.perc*self.Pulse.speed;
				self.Scale.y = self.Scale.y - self.Pulse.perc*self.Pulse.speed;
			else
				self.PulseDir = 0;
			end
		elseif( self.PulseDir == 0 ) then
			if( self.CurPulse > 0 ) then
				self.CurPulse = self.CurPulse - self.Pulse.speed;
				self.Scale.x = self.Scale.x - self.Pulse.perc*self.Pulse.speed;
				self.Scale.y = self.Scale.y + self.Pulse.perc*self.Pulse.speed;
			else
				self.PulseDir = 1;
			end
		end
	end


	if( self.Looped and self.Running and self.CurrentFrame == #self.Frames ) then
		self:Reset();
		self:Play();
		return;
	end

	if(self.Running and self.CurrentFrame == #self.Frames) then
		self.Running = false
		self:OnEnd();
	end

	if( self.Magnet ) then
		self.Magnet:Update(dt);
	end
	if( self.Balloon ) then
		self.Balloon:Update(dt);
	end

end

function CAnimation:Pulsate(speed, p, size)
	self.Pulse = { speed = speed, perc = p, size = size };
end

function CAnimation:Wobble(px, py)
	self.Wobbles = { x = px or 0, y = py or 0 };
end

function CAnimation:OnEnd()
end

function CAnimation:OnStart()
end

function CAnimation:OnPause()
end

function CAnimation:OnFrameChange()
end

function CAnimation:Draw()

	love.graphics.setColor(self.Color);
	if( self.Phys and self.Phys.Body ) then
		if( self.IsCircle ) then
			local rx = (self.Rad*2/self.Frames[self.CurrentFrame]:getWidth())*SLING.Screen.Scale.x;
			local ry = (self.Rad*2/self.Frames[self.CurrentFrame]:getHeight())*SLING.Screen.Scale.y;
			love.graphics.draw(self.Frames[self.CurrentFrame], self.Phys.Body:getX(), self.Phys.Body:getY(), self.Phys.Body:getAngle(),rx, rx, self.Origin.x, self.Origin.y);
		else
			love.graphics.draw(self.Frames[self.CurrentFrame], self.Phys.Body:getX(), self.Phys.Body:getY(), self.Phys.Body:getAngle(), self.Scale.x, self.Scale.y, self.Origin.x, self.Origin.y);
		end
	end
	if not(self.Phys) then
		love.graphics.draw(self.Frames[self.CurrentFrame], self.Pos.x, self.Pos.y, math.rad(self.Rotation), self.Scale.x, self.Scale.y, self.Origin.x, self.Origin.y);
	end

	--if( self.Phys and self.Phys.Body ) then
	--	if( self.IsCircle ) then
	--		love.graphics.circle("line", self.Phys.Body:getX(), self.Phys.Body:getY(), self.Rad);
	--	else
	--		love.graphics.polygon("line", self.Phys.Body:getWorldPoints(self.Phys.Shape:getPoints()));
	--	end
	--end

end


function CAnimation:Shutdown()
end