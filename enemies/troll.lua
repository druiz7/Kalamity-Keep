local Enemy = require("Enemy")

local troll = Enemy:new( {name='troll', HP=2, damage=2, speed=2} )


-->create the frames for the enemy
local options = {frames={
	{x=??, y=??, height=??, width=??},
	{x=??, y=??, height=??, width=??},
	{x=??, y=??, height=??, width=??}
}}

local sheet = graphics.newImageSheet("troll.png", options)

local seqTroll = {
	{name="walk", frames={...}, time=500}
}


--> spawn the enemies
function Enemy:spawn(xSpawn, ySpawn)
	self.enemy = display.newSprite(sheet, seqTroll) -- create a new object
	self.enemy.pp = self;      -- parent pointer to parent object
	self.enemy.name = self.name; --“enemy”
	physics.addBody(self.enemy, "kinematic"); 
end
