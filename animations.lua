--[[
	Sling Hoops
]]--


function AnimationFromName(name, pos)

	local scalex = SLING.Screen.Width/800;
	local scaley = SLING.Screen.Height/480;

	if not ANIMATION[name] then
		print("Animation: "..name.." does not exist!");
		return;
	end

	local anim = ANIMATION[name];
	local newAnim = new "CAnimation";
	newAnim:NewAnimation(anim.Images, anim.Time);
	newAnim:SetPos(pos.x,pos.y);
	newAnim:SetScale(anim.Scale*scalex, anim.Scale*scaley);
	newAnim:CenterOrigin();

	return newAnim;

end


ANIMATION = {}

ANIMATION.balloon_pop = {
	
	Name = "balloon_pop",

	Type = "Checkpoint",

	PhysicsEnabled = false,
	PhysScale = 0.8,
	PhysType = "static",

	Images = { 
		"textures/endpoints/balloon_pop/ballon_checkpoint_01.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_02.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_03.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_04.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_05.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_06.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_07.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_08.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_09.png",
		"textures/endpoints/balloon_pop/ballon_checkpoint_10.png"
	},

	Time = 0.8,

	Scale = 0.11

}

ANIMATION.button = {
	
	Name = "button",

	Type = "Button",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",

	Images = {
		"textures/objects/button/button_01.png",
		"textures/objects/button/button_02.png",
		"textures/objects/button/button_03.png",
		"textures/objects/button/button_04.png"
	},

	Time = 0.4,

	Scale = 0.22

}

ANIMATION.spacebutton = {
	
	Name = "spacebutton",

	Type = "Button",

	PhysicsEnabled = true,
	PhysScale = 0.8,
	PhysType = "static",

	Images = {
		"textures/objects/button/spaceship_button.png",
		"textures/objects/button/spaceship_button1.png"
	},

	Time = 0.2,

	Scale = 0.3

}

ANIMATION.magnetbutton = {
	
	Name = "magnetbutton",

	Type = "MagnetButton",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",

	Images = {
		"textures/objects/button/magnet1.png",
		"textures/objects/button/magnet2.png",
		"textures/objects/button/magnet3.png"
		--"textures/objects/button/magnet4.png"
	},

	Time = 0.4,

	Scale = 0.17

}

ANIMATION.coin = {

	Name = "coin",

	Type = "Coin",

	PhysicsEnabled = false,
	PhysScale = 0.95,
	PhysType = "static",

	Images = {
		"textures/objects/coin/coin1.png",
		"textures/objects/coin/coin2.png",
		"textures/objects/coin/coin3.png",
		"textures/objects/coin/coin4.png",
		"textures/objects/coin/coin5.png",
		"textures/objects/coin/coin6.png"
	},

	Time = 0.8,

	Scale = 0.25

}

ANIMATION.stars = {
	
	Name = "stars",

	Type = "Stars",

	PhysicsEnabled = false,
	PhysScale = 0.95,
	PhysType = "static",

	Images = {
		"textures/stars/stars1.png",
		"textures/stars/stars2.png",
		"textures/stars/stars3.png",
		"textures/stars/stars4.png",
	},

	Time = 3.2,

	Scale = 1

}

ANIMATION.outspikes = {

	Name = "outspikes",

	Type = "Spikes",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/outdoor_spikes.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.mountspikes = {

	Name = "mountspikes",

	Type = "Spikes",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/mountain_spikes.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.medispikes = {

	Name = "medispikes",

	Type = "Spikes",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/medieval_spikes.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.swampspikes = {

	Name = "swampspikes",

	Type = "Spikes",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/swamp_spikes.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.crate = {

	Name = "crate",

	Type = "Crate",

	PhysicsEnabled = true,
	PhysScale = 0.80,
	PhysType = "dynamic",
	Pulse = false,

	Images = {
		"textures/objects/crate.png"
	},

	Time = 1,

	Scale = 0.018

}

ANIMATION.cratesmall = {
	
	Name = "cratesmall",

	Type = "Crate",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse = false;

	Images = {
		"textures/objects/crate.png"
	},

	Time = 1,

	Scale = 0.008

}

ANIMATION.woodplank = {
		
	Name = "woodplank",

	Type = "Plank",

	PhysicsEnabled = true,
	PhysScale = 0.85,
	PhysType = "dynamic",
	Pulse = false,

	Images = {
		"textures/objects/woodplank.png"
	},

	Time = 1,

	Scale = 0.1

}

ANIMATION.smallplank = {
		
	Name = "smallplank",

	Type = "Plank",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse = false,

	Images = {
		"textures/objects/woodplank.png"
	},

	Time = 1,

	Scale = 0.035

}

ANIMATION.cball = {
	
	Name = "cball",

	Type = "Cball",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse = false,

	Circle = true,
	Radius = 10,

	Images = {
		"textures/balls/cannonball.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.book1 = {
	
	Name = "book1",

	Type = "Book",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse= false,

	Images = {
		"textures/objects/book1.png"
	},

	Time = 1,

	Scale = 0.04

}


ANIMATION.portalentry = {
	
	Name = "portalentry",

	Type = "PortalEntry",

	PhysicsEnabled = true,
	PhysScale = 0.9,
	PhysType = "static",
	Pulse= false,

	Images = {
		"textures/objects/portal.png"
	},

	Time = 1,

	Scale = 0.072

}


ANIMATION.portalexit = {
	
	Name = "portalexit",

	Type = "PortalExit",

	PhysicsEnabled = false,
	PhysScale = 0.9,
	PhysType = "static",
	Pulse= false,

	Images = {
		"textures/objects/portal.png"
	},

	Time = 1,

	Scale = 0.072

}

ANIMATION.book2 = {
	
	Name = "book2",

	Type = "Book",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse= false,

	Images = {
		"textures/objects/book2.png"
	},

	Time = 1,

	Scale = 0.04

}

ANIMATION.book3 = {
	
	Name = "book3",

	Type = "Book",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse= false,

	Images = {
		"textures/objects/book3.png"
	},

	Time = 1,

	Scale = 0.05

}

ANIMATION.book4 = {
	
	Name = "book4",

	Type = "Book",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse= false,

	Images = {
		"textures/objects/book4.png"
	},

	Time = 1,

	Scale = 0.06

}

ANIMATION.book5 = {
	
	Name = "book5",

	Type = "Book",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "dynamic",
	Pulse= false,

	Images = {
		"textures/objects/book5.png"
	},

	Time = 1,

	Scale = 0.06

}

ANIMATION.plat1 = {

	Name = "plat1",

	Type = "Platform",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = false,

	Images = {
		"textures/objects/platform1.png"
	},

	Time = 1,

	Scale = 0.42

}

ANIMATION.plat2 = {

	Name = "plat2",

	Type = "Platform",

	PhysicsEnabled = true,
	PhysScale = 0.7,
	PhysType = "static",
	Pulse = false,

	Images = {
		"textures/objects/platform2.png"
	},

	Time = 1,

	Scale = 0.42

}

ANIMATION.bush1 = {
	
	Name = "bush1",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/dark_bush.png"
	},

	Time = 1,

	Scale = 0.7

}

ANIMATION.bush2 = {
	
	Name = "bush2",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",
	Pulse = true,

	Images = {
		"textures/objects/green_bush.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.bush3 = {
	
	Name = "bush3",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",

	Images = {
		"textures/objects/swamp_shrub.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.bush4 = {
	
	Name = "bush4",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",

	Images = {
		"textures/objects/swamp_mud.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.bush5 = {
	
	Name = "bush5",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",

	Images = {
		"textures/objects/red_bush1.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.bush6 = {
	
	Name = "bush6",

	Type = "Bush",

	PhysicsEnabled = false,
	PhysScale = 1,
	PhysType = "static",

	Images = {
		"textures/objects/red_bush2.png"
	},

	Time = 1,

	Scale = 0.6

}

ANIMATION.magnet = {
	
	Name = "magnet",

	Type = "Magnet",

	PhysicsEnabled = true,
	PhysScale = 0.8,
	PhysType = "static",
	Pulse = false,

	Images = {
		"textures/objects/magnet.png"
	},

	Time = 1,

	Scale = 0.04

}

ANIMATION.balloon = {
	
	Name = "balloon",

	Type = "Balloon",

	PhysicsEnabled = true,
	PhysScale = 0.6,
	PhysType = "dynamic",
	Pulse = false,

	Images = {
		"textures/objects/balloon.png"
	},

	Time = 1,

	Scale = 0.03

}

ANIMATION.door = {
	
	Name = "door",

	Type = "Door",

	PhysicsEnabled = true,
	PhysScale = 1,
	PhysType = "static",
	Pulse = false,

	Images = {
		"textures/objects/door.png"
	},

	Time = 1,

	Scale = 0.1

}
