--[[
	Sling Hoops
]]--

-- POP SOUND! 
-- basketball_bounce.mp3 - pitch 0.825

SLING.BallTypes = {
	
	basketball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 1
		},

		Radius = 10,

		Image = love.graphics.newImage("textures/balls/basketball.png"),
		Price = 50000,
		MassMultiplyer = 1,
		Restitution = 0.8,
		NoPop = false,
		Weight = "Average"
	},

	beachball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 1.4
		},

		Radius = 10,

		Image = love.graphics.newImage("textures/balls/beachball.png"),
		Price = 55000,
		MassMultiplyer = 1.3,
		Restitution = 0.6,
		NoPop = false,
		Weight = "Light"
	},

	bowlingball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 0.5
		},

		Radius = 10,
		Image = love.graphics.newImage("textures/balls/bowlingball.png"),
		Price = 59000,
		MassMultiplyer = 1.7,
		Restitution = 0.3,
		NoPop = true,
		Weight = "Heavy"
	},

	cannonball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 0.4
		},

		Radius = 10,

		Image = love.graphics.newImage("textures/balls/cannonball.png"),
		Price = 50000,
		MassMultiplyer = 1.7,
		Restitution = 0.2,
		NoPop = true,
		Weight = "Heavy"
	},

	soccerball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 0.8
		},

		Radius = 10,
		Image = love.graphics.newImage("textures/balls/soccerball.png"),
		Price = 65000,
		MassMultiplyer = 1.1,
		Restitution = 0.7,
		NoPop = false,
		Weight = "Average"
	},

	tennisball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 0.65
		},

		Radius = 8,

		Image = love.graphics.newImage("textures/balls/tennisball.png"),
		Price = 70000,
		MassMultiplyer = 1,
		Restitution = 0.7,
		NoPop = true,
		Weight = "Light"
	},

	eightball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 0.5
		},

		Radius = 8,

		Image = love.graphics.newImage("textures/balls/eightball.png"),

		Price = 70000,
		MassMultiplyer = 2,
		Restitution = 0.2,
		NoPop = true,
		Weight = "Average"
	},

	bouncyball = {
		Sound = {
			Bounce = love.audio.newSource("sounds/basketball_bounce.mp3", "static"),
			Pitch = 1.3
		},

		Radius = 5,

		Image = love.graphics.newImage("textures/balls/bouncyball.png"),

		Price = 20000,
		MassMultiplyer = 1,
		Restitution = 1,
		NoPop = true,
		Weight = "Tiny"
	}


}