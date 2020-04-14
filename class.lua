--[[
	Sling Hoops
]]--

_shardClass = {}
setmetatable(_shardClass, {});

function class(nme)
	if( _G[nme] ) then
		print("Class: "..nme.." already exists.");
		return;
	end
	_G[nme] = {}
	setmetatable(_G[nme], {__index =_shardClass})
	_G[nme].istype = nme;
	return _G[nme];
end

-- Really no reason for the shardClass metatable but it provides nice looking functionality'
--[[ 	class "CAnimatedEntity" : extends "CBaseEntity"  	<-- is now correct syntax	 ]]--
function _shardClass:extends(superclass)
	if( _G[superclass] ) then
		self.parent = superclass;
		setmetatable(self, {__index=_G[superclass]});
	end
end

function new(class)
	if( _G[class] ) then
		local newClass = {}
		setmetatable(newClass, _G[class]);
		getmetatable(newClass).__index = _G[class];
		if( newClass.Init ) then
			newClass:Init();
		end
		return newClass;
	end
	print("Class: "..class.." does not exist.");
end


