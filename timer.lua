--[[
	Shard Engine
	Developed by Averice.
]]--

timer = {}

Timers = {}
Timers.Simple = {}
Timers.Recur = {}

function timer.Create(te, re, ne, fe, ...)
	if( not te or not re or not ne or not fe ) then
		print("Timer Error: Invalid arguments [ time , repetitions, uniqueName, function [ , args ] ]");
		return
	end
	if( Timers.Recur[ne] ) then
		print("Timer Error: uniqueName already taken [ "..ne.." ]");
		return
	end
	local timer = {}
	timer.delay = te;
	timer.lastran = love.timer.getTime();
	timer.args = {...};
	timer.reps = math.abs(re);
	timer.inf = timer.reps == 0 or false;
	timer.func = fe;
	Timers.Recur[ne] = timer;
end

function timer.Simple(de, fu, ...)
	if( not de or  not fu ) then
		print("Timer Error: Invalid arguments for timer.Simple [ delay, function ]");
		return
	end
	local pass = {...}
	table.insert(Timers.Simple, { d = love.timer.getTime() + math.abs(de), f = fu, a = pass });
end

function timer.Call(n)
	if not n then
		print("Timer Call: uniqueName not specifed");
		return
	end
	if( Timers.Recur[n] ) then
		local succ, err = pcall(Timers.Recur[n].func, unpack(Timers.Recur[n].args));
		if( not succ ) then
			print("Timer Error[ "..n.." ]: "..tostring(err));
			return
		end
	else
		print("Timer Call: uniqueName not found");
		return
	end
end

function timer.Remove(n, noerr)
	if not n or not Timers.Recur[n] then
		if not noerr then
			print("Timer Remove: uniqueName not found");
		end
		return;
	end
	Timers.Recur[n] = nil;
end

function timer.Pause(n)
	if not n or not Timers.Recur[n] then
		print("Timer Pause: uniqueName not found");
		return;
	end
	Timers.Recur[n].pause = true;
end

function timer.Continue(n)
	if not n or not Timers.Recur[n] then
		print("Timer Continue: uniqueName not found");
		return;
	end
	if( Timers.Recur[n].pause ) then
		Timers.Recur[n].pause = false;
		return;
	end
	print("Timer Continue: Timer: "..n.." was not paused [cannot continue a running timer]");
end

local succ,err
local mT = love.timer.getTime
local function timerCall()
	for k, v in pairs(Timers.Recur) do
		if( mT() - v.lastran >= v.delay and (v.inf or v.reps > 0) and not v.pause ) then
			timer.Call(k)
			v.reps = v.reps-1;
			v.lastran = mT();
		end
	end
	if( Timers.Simple[1] ) then
		for i = #Timers.Simple, 1, -1 do
			if( Timers.Simple[i].d <= mT() ) then
				succ, err = pcall(Timers.Simple[i].f, unpack(Timers.Simple[i].a));
				if( not succ ) then
					print("Timer Simple Error: "..tostring(err));
				end
				table.remove(Timers.Simple, i);
			end
		end
	end
end
timer.Update = timerCall;