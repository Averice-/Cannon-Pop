--[[
	Sling Hoops
]]--

callbacks = {}

local box_break_snd = love.audio.newSource("sounds/crate_break.wav", "static");
local magnet_on = love.audio.newSource("sounds/magnet_on.wav", "static");
local portal = love.audio.newSource("sounds/portal.wav", "static");

function callbacks.BeginContact(a, b, c)

	if( a:getUserData() or b:getUserData() ) then
		if( a:getUserData() == "basketball" or b:getUserData() == "basketball" ) then
			if( SLING.Game.Bounces <=7 ) then
				SLING.Game.Bounces = SLING.Game.Bounces + 1;
			end
			local curball = SLING.BallTypes[SLING.Player.Data.SelectedSkin];
			local snd = curball.Sound;
			if( SLING.Game.LevelEndNow ) then
				snd.Bounce:setPitch(0.15);
				snd.Bounce:setVolume(0.8);
			else
				snd.Bounce:setPitch(snd.Pitch+(0.025*SLING.Game.Bounces));
				snd.Bounce:setVolume(0.8);
			end
			if( SLING.Game.Bounces < 7 ) then
				snd.Bounce:stop();
				snd.Bounce:play();
			end

			if( a:getUserData() and a:getUserData().Type and a:getUserData().Type == "Spikes" ) or ( b:getUserData() and b:getUserData().Type and b:getUserData().Type == "Spikes" ) then

				if not( curball.NoPop ) then
					-- PARTICLES YAY!
					if( SLING.Game.Cannon and SLING.Game.Cannon.Ball and SLING.Game.Cannon.Ball.Body ) then
						SLING.Game.Cannon.Ball:Delete();
						local popsnd = SLING.BallTypes.tennisball.Sound.Bounce;
						popsnd:setPitch(0.825);
						popsnd:play();
					end
				end

			end

		end

		if( a:getUserData() == "OUTOFBOUNDS"  or b:getUserData() == "OUTOFBOUNDS" ) then
			if( a:getUserData() == "basketball" or b:getUserData() == "basketball" ) then
		 		if( SLING.Game.Cannon and SLING.Game.Cannon.Ball and SLING.Game.Cannon.Ball.Body ) then
					SLING.Game.Cannon.Ball:Delete();
					local popsnd = SLING.BallTypes.tennisball.Sound.Bounce;
					popsnd:setPitch(0.825);
					popsnd:play();
				end
			end
		end

		if( (a:getUserData() and a:getUserData().Type and a:getUserData().Type == "Button") or (b:getUserData() and b:getUserData().Type and b:getUserData().Type == "Button") ) then
			if( a:getUserData().Type == "Button" ) then
				if not a:getUserData().Pressed then
					a:getUserData():Play();
					a:getUserData().Pressed = true;
				end
			elseif( b:getUserData().Type == "Button" ) then
				if not b:getUserData().Pressed then
					b:getUserData():Play();
					b:getUserData().Pressed = true;
				end
			end
		end

		if( (a:getUserData() and a:getUserData().Type and a:getUserData().Type == "MagnetButton") or (b:getUserData() and b:getUserData().Type and b:getUserData().Type == "MagnetButton") ) then
			if not a:getUserData().Pressed then
				a:getUserData():Play();
				a:getUserData().Pressed = true;
				magnet_on:play();
			end
		end

		if( (a:getUserData() and a:getUserData().Type and a:getUserData().Type == "Crate") or (b:getUserData() and b:getUserData().Type and b:getUserData().Type == "Crate") or (a:getUserData() and a:getUserData().Type and a:getUserData().Type == "Door") or (b:getUserData() and b:getUserData().Type and b:getUserData().Type == "Door") ) then
			if( a:getUserData() == "basketball" or b:getUserData() == "basketball" ) then
				if( SLING.Player.Data.SelectedSkin == "cannonball" or SLING.Player.Data.SelectedSkin == "bowlingball" ) then
					if( b:getUserData().Type and b:getUserData().Type == "Crate" ) then
						b:getUserData().Phys.Body = nil
						b:getBody():destroy();
						box_break_snd:play();
					else
						a:getUserData().Phys.Body = nil
						a:getBody():destroy();
						box_break_snd:play();
					end
				elseif( b:getUserData().Type and b:getUserData().Type == "Door" ) then
					b:getUserData().Phys.Body = nil;
					b:getBody():destroy();
					box_break_snd:play();
				elseif( a:getUserData().Type and a:getUserData().Type == "Door" ) then
					a:getUserData().Phys.Body = nil;
					a:getBody():destroy();
					box_break_snd:play();
				end
			end
		end
	end

end

function callbacks.PreSolve(a, b, c)

	if( a:getUserData() == "basketball" or b:getUserData() == "basketball" ) then

		if( (a:getUserData() and a:getUserData().Type and a:getUserData().Type == "PortalEntry") or (b:getUserData() and b:getUserData().Type and b:getUserData().Type == "PortalEntry") ) then
				
			local velx, vely = SLING.Game.Cannon.Ball.Body:getLinearVelocity();-- portals maybe?


			--velx, vely = velx/SLING.Game.Cannon.Ball.Body:getMass(), vely/SLING.Game.Cannon.Ball.Body:getMass();

			velx = math.cos(math.rad(SLING.Game.PortalExitRot)) * velx;
			vely = math.sin(math.rad(SLING.Game.PortalExitRot)) * vely;



			SLING.Game:PortalActive(SLING.Game.PortalExitPos.x, SLING.Game.PortalExitPos.y, velx, vely);
			portal:play();
				--SLING.Game.Cannon.Ball.Body:setPosition();
				--SLING.Game.Cannon.Ball.Body:setLinearVelocity();

			c:setEnabled(false);

		end

	end

end


--	SOUNDS
--		BACKGROUND MUSIC
--			MENU
--			GAME
--			WIN SCREEN
--		CANNON NEW SOUND
--		SKIN SOUNDS
--		BALLOON POP
--		GET COINS

--	PARTICLE EFFECTS
--		LEVEL END
--		CANNON FIRE
--		BALL POP
--		LEVEL LOAD
--		GET COINS

