--[[
	Sling Hoops
]]--


class "CStateManager";

function CStateManager:Init()
	self.States = {}
end

function CStateManager:Push(state, init)
	if( ctype(state) == "CState" ) then
		self.States[#self.States+1] = state;
		if( init ) then
			if( self.States[#self.States-1] and self.States[#self.States-1].isinit ) then
				self.States[#self.States-1]:Shutdown();
				self.States[#self.States-1].isinit = false;
			end
			self.States[#self.States]:Init();
			self.States[#self.States].isinit = true;
		end
	else
		print("StateManager: CStateManager.Push expected CState got: "..ctype(state));
	end
end

function CStateManager:InitCurrentState()
	if( self.States[1] and not self.States[#self.States].isinit ) then
		self.States[#self.States]:Init();
		self.States[#self.States].isinit = true;
	end
end

function CStateManager:Pop()
	if( self.States[1] ) then
		if( self.States[#self.States].isinit ) then
			self.States[#self.States].isinit = false;
			self.States[#self.States]:Shutdown();
		end
		local oldState = self.States[#self.States];
		self.States[#self.States] = nil;
		self:InitCurrentState();
		return oldState;
	end
	print("StateManager: Called CStateManager.Pop with empty stack");
end

function CStateManager:GetAll()
	return self.States
end

function CStateManager:GetActive()
	if( self.States[1] and self.States[#self.States].isinit ) then
		return self.States[#self.States];
	end
	--print("StateManager: Called CStateManager.GetActive with no running states");
end

function CStateManager:Pause(state)
	if( ctype(state) == "CState" ) then
		state.paused = true;
	end
end

function CStateManager:Resume(state)
	if( ctype(state) == "CState" ) then
		state.paused = false;
	end
end

function CStateManager:IsPaused(state)
	if( ctype(state) == "CState" ) then
		return state.paused;
	end
end

function CStateManager:Call(func, ...)
	if( self.States[1] and self.States[#self.States].isinit and not self.States[#self.States].paused ) then
		if( self.States[#self.States][func] ) then
			self.States[#self.States][func](self.States[#self.States], ...);
		end
	end
end
